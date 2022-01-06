require 'ostruct'
require 'json'
require 'awesome_print'
require 'table_print'
require 'byebug'

def round_price(price)
  (price * 100).to_i / 100.0
end

def format_price(price)
  "R$%0.2f" % price
end

def format_percentage(ratio)
  "#{(ratio * 10000).to_i / 100.0}%"
end

class HcrxStruct < OpenStruct
end
