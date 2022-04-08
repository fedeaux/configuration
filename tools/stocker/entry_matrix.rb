require_relative './stocker.rb'

financial_risk = 1000
# price_ranges = [[2.5, 5], [5, 7.5], [7.5, 10], [10, 15], [15, 20], [20, 25], [25, 30], [30, 35], [35, 40], [40, 50], [50, 65], [65, 80], [80, 100], [100, 120]]

min_prices = 26.times.map do |i|
  (i * i * 0.1 + 2 * i + 1).round
end

min_prices.each do |min_price|
  puts min_price
end

price_ranges = []
current_min_price_index = 0

while min_prices[current_min_price_index + 1]
  price_ranges.push [min_prices[current_min_price_index + 0], min_prices[current_min_price_index + 1]]
  current_min_price_index += 1
end

stops = 10.times.map do |i|
  (i + 1) / 400.0
end

row = stops.map do |stop|
  format_percentage(stop)
end

row.unshift ''

rows = [row]

price_ranges.each do |price_range|
  min_price = price_range[0]
  max_price = price_range[1]
  average_price = (min_price + max_price + max_price) / 3.0
  row = ["#{format_price(max_price)}"]

  stops.each do |stop|
    entry_value = financial_risk / stop
    row.push min_multiple_of(entry_value / average_price, 100)
  end

  rows.push row
end

rows.each do |row|
  puts (row.join(";"))
end
