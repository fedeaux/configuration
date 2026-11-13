require 'erb2slim'

filenames = []

for arg in ARGV
  if arg.end_with? '.html.erb'
    filenames.push arg
  end
end

filenames.each do |filename|
  full_name = "#{Dir.pwd}/#{filename}"

  erb_template_string = File.read full_name
  slim_template_string = Erb2Slim.convert erb_template_string

  puts erb_template_string
end
