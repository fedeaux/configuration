require 'yaml'
require 'json'
require "action_view"
require "active_support/all"
require 'awesome_print'
require 'byebug'
require 'date'
require 'json'
require 'ostruct'
require 'table_print'
# require 'nokogiri'
require 'httparty'

# class Hash
#   def _deep_transform_keys_in_object(object, &block)
#     case object
#     when Hash
#       object.each_with_object({}) do |(key, value), result|
#         result[yield(key)] = _deep_transform_keys_in_object(value, &block)
#       end
#     when Array
#       object.map { |e| _deep_transform_keys_in_object(e, &block) }
#     else
#       object
#     end
#   end

#   def deep_transform_keys(&block)
#     _deep_transform_keys_in_object(self, &block)
#   end

#   def deep_symbolize_keys
#     deep_transform_keys { |key| key.to_sym rescue key }
#   end
# end

class FedeauxMode
  CLASS_REGEX = r = /
    \A           # match the beginning of the string
    [A-Z]        # match an upper case English letter
    \p{Alnum}*   # match zero or more Unicode letters or digits
    \z           # match the end of the string
    /x           # free-spacing regex definition mode

  attr_accessor :a, :response

  def initialize(args)
    self.a = JSON.parse(args.first).deep_symbolize_keys
    self.response = {}

    # DUCT TAPE
    if a[:command] == 'smart_guess'
      self.smart_guess
    end

    puts self.response.to_json

    # # puts "@a: #{@a.merge(porra: 'caralho')}"

    # # puts "a: #{a}"
    # # return

    # # @dir = args.first
    # # load_dot_fedeaux
    # # return unless args[1]

    # # send args[1], *args[2..-1]
    # # persist_dot_fedeaux
    # puts ({ te: 'respondo' }.to_json)

    # options = []

    # if @a[]
    # end
  end

  def cmd(s)
    Dir.chdir(@dir) do
      `#{s}`
    end
  end

  def git_branch
    @git_branch ||= cmd('git rev-parse --abbrev-ref HEAD').strip
  end

  def parent_git_branch
    @parent_git_branch ||= cmd(%Q{git show-branch | grep '\*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1}).match(/\[(\w+).*\]/)[1]
  rescue Exception => e
    nil
  end

  def dot_fedeaux_path
    "#{@dir}.fedeaux.yml"
  end

  def load_dot_fedeaux
    ensure_dot_fedeaux
    @config = YAML.load dot_fedeaux_path
  end

  def persist_dot_fedeaux
    File.open(dot_fedeaux_path, 'w') do |f|
      f.write(@config.to_yaml)
    end
  end

  def ensure_dot_fedeaux
    return if File.exist? dot_fedeaux_path

    File.open(dot_fedeaux_path, 'w') do |f|
      f.write('')
    end
  end

  # Commands
  def smart_guess
    self.response[:smart] = true
    options = []

    if self.a[:file_name].last(5) == '.slim'
      # options.push({ command: 'erb2slim' })

      require 'erb2slim'

      self.response = {
        command: :replace,
        target: :region,
        with: Erb2Slim.convert(self.a[:selected_text])
      }
    end

    # if options.count == 1
    #   self.response[:command] = options.first
    # end
  end

  def find_thing(thing_name)
    if thing_name.match? CLASS_REGEX
      puts cmd("find #{@dir} | grep #{class_to_file_name(thing_name)}").strip
    end
  end

  def class_to_file_name(class_name)
    "/#{underscore(class_name)}.rb"
  end

  def list_branch(*)
    if parent_git_branch
      puts cmd("git diff --name-only $(git merge-base #{git_branch} #{parent_git_branch})").strip
    else
      puts cmd("git diff --name-only HEAD~10..HEAD").strip
    end
  end

  def favorites_add(file_name)
    @config['favorites'] ||= {}
    @config['favorites'][git_branch] ||= []
    @config['favorites'][git_branch] << file_name
    @config['favorites'][git_branch] = @config['favorites'][git_branch].uniq.sort

    puts "Added #{file_name.split('/').last} to #{git_branch} favorites"
  end

  def favorites_find
    @config['favorites'] && @config['favorites'][git_branch]
  end

  def underscore(camel_cased_word)
    return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)
    word = camel_cased_word.to_s.gsub("::", "/")
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

  # Commands support
  def smart_guess_region(region)
    return module_hierarchy_as_single_line(region) if looks_like_module_hierarchy?(region)
    return variables_to_hash(region) if looks_like_a_list_of_variables?(region)
  end

  def variables_to_hash(region)
    spaces = false

    hash = region.split("\n").reject{ |l| l.strip.length == 0 }.map { |line|
      parts = line.split('=')
      spaces ||= ' ' * (line.length - line.lstrip.length)

      "  #{spaces}#{parts.first.strip}: #{parts[1..-1].join.strip}"
    }.join ",\n"

    [{ action: 'replace-region', args: "#{spaces}{\n#{hash}\n#{spaces}}\n" }]
  end

  def module_hierarchy_as_single_line(region)
    modules_and_classes = []
    initialize = nil

    region.split("\n").each do |line|
      line.strip!

      if line.start_with? /class|module/
        modules_and_classes << line.split(' ')[1..-1].join(' ').split('<').first.strip
      elsif line.start_with? /def initialize/
        initialize = line.split('(')[1..-1].join('(')
      end
    end


    [{ action: 'copy-to-clipboard', args: modules_and_classes.join('::') + (initialize ? ".new(#{initialize}" : '') }]
  end

  def looks_like_a_list_of_variables?(region)
    region.split("\n").reject{ |l| l.strip.length == 0 }.all? { |line|
      line.strip =~ /\w+\s+=.*/
    }
  end

  def looks_like_module_hierarchy?(region)
    region.strip.start_with? 'module'
  end
end

FedeauxMode.new ARGV
