require_relative './stocker'

wallet = OpenStruct.new(
  dividends: 100000,
  fiis: 50000
)

day = Date.parse('01-01-2022')
last_day = Date.parse('23-11-2023')
input_factor = 1.075
input = 50000

while last_day > day
  day += 1.month

  input *= input_factor
  one_third = (input / 3).to_i

  wallet.dividends += one_third * 2
  wallet.fiis += one_third

  puts "#{day}: dividends #{format_price(wallet.dividends)}, fiis: #{format_price(wallet.fiis)}, input: #{input}"
end
