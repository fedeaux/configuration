# config/boot.rb
require 'rubygems'
require 'bundler/setup'

# Load all gems from Gemfile
Bundler.require(:default)

# Add project to load path
Dir['lib/**/*.rb'].each do |file|
  require "#{Dir.pwd}/#{file}"
end

FileUtils.mkdir_p Catanner::SCREENSHOTS_DIR

# lib_path = File.expand_path('../lib', __dir__)
# $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
