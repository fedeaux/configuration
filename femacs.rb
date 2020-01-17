require 'json'

class Femacs
  def initialize(args)
    @dir = args.first
    find_git_branch
    load_dot_femacs
    return unless args[1]

    send args[1], *args[2..-1]
    persist_dot_femacs
  end

  def cmd(s)
    Dir.chdir(@dir) do
      `#{s}`
    end
  end

  def find_git_branch
    @git_branch = cmd('git branch').split("\n").select { |l| l.start_with? '*' }.first[2..-1]
  end

  def dot_femacs_path
    "#{@dir}.femacs"
  end

  def load_dot_femacs
    ensure_dot_femacs
    @config = JSON.load File.read dot_femacs_path
  end

  def persist_dot_femacs
    File.open(dot_femacs_path, 'w') do |f|
      f.write(@config.to_json)
    end
  end

  def ensure_dot_femacs
    return if File.exist? dot_femacs_path

    File.open(dot_femacs_path, 'w') do |f|
      f.write('{}')
    end
  end

  def favorites_add(file_name)
    @config['favorites'] ||= {}
    @config['favorites'][@git_branch] ||= []
    @config['favorites'][@git_branch] << file_name
    @config['favorites'][@git_branch] = @config['favorites'][@git_branch].uniq.sort

    puts "Added #{file_name.split('/').last} to #{@git_branch} favorites"
  end

  def favorites_find
    puts @config['favorites'] && @config['favorites'][@git_branch]
    @config['favorites'] && @config['favorites'][@git_branch]
  end
end

Femacs.new ARGV
