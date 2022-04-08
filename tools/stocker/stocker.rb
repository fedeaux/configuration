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

include ActionView::Helpers::NumberHelper

def round_price(price)
  (price * 100).to_i / 100.0
end

def format_price(price, currency: 'R$')
  number_to_currency(price)

  # "#{currency}%0.2f" % price
end

def format_percentage(ratio)
  "#{(ratio * 10000).to_i / 100.0}%"
end

def min_multiple_of(number, base)
  (number / base).to_i * base
end

def parse_money(string)
  string.gsub(/[^\d]/, '').to_i / 100.0
end

class HcrxStruct < OpenStruct
end
