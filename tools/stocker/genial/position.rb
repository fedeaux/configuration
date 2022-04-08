# P1LD34, PLD
# SIMN34, SPG
# T1OW34, AMT
# EQIX34, EQIX
# S2UI34, SUI

require_relative '../stocker'

html_doc = Nokogiri::HTML File.read("#{__dir__}/position/2022-apr-06.html")
dy_wallet_stocks_map = {}
fiis_map = {}

class UserStockPosition
  attr_accessor :code, :average_buy_price, :current_price, :count, :current_position

  def initialize(code:)
    self.code = code
    self.count = 0
    self.current_position = 0
  end
end

%w[
    CSAN3
    GOAU4
    KLBN11
    CSMG3
    BBAS3
    VIVT3
    IRBR3
    PSSA3
    SULA11
    CPLE6
    ENBR3
    EGIE3
    TAEE11
    TRPL4
    ALUP11
    AURA33
    EQIX34
    SIMN34
    P1LD34
    CATP34
    CMCS34
    MMMC34
    A1TM34
  ].each do |code|
  dy_wallet_stocks_map[code] = UserStockPosition.new(code: code)
end

%w[
    XPSF11
    CPFF11
    RFOF11
    BCFF11
    OURE11
    RELG11
    TGAR11
    BBPO11
    TORD11
    VSLH11
    HCTR11
  ].each do |code|
  fiis_map[code] = UserStockPosition.new(code: code)
end

other_stocks = []

html_doc.css('tr')[0].tap do |tr|
  puts tr.css('th').map(&:text).join('  |  ')
end

html_doc.css('tr')[1..-1].map do |tr|
  tds = tr.css('td')
  code = tds[0].text.strip
  stock = dy_wallet_stocks_map[code] || fiis_map[code]

  unless stock
    stock = UserStockPosition.new(code: code)
    other_stocks.push stock
  end

  stock.current_position = parse_money(tds[1].text)
  stock.count = tds[2].text.gsub(/[^\d]/, '').to_i
end

tp dy_wallet_stocks_map.values, :code, :count, :current_position

csv = dy_wallet_stocks_map.values.map do |stock|
  [stock.code, stock.count, stock.current_position].join ';'
end.join "\n"

csv += "\n   -----------------  "

csv += fiis_map.values.map do |stock|
  [stock.code, stock.count, stock.current_position].join ';'
end.join "\n"

csv += "\n   -----------------  "

csv += other_stocks.map do |stock|
  [stock.code, stock.count, stock.current_position].join ';'
end.join "\n"

puts csv
