require_relative './stocker.rb'

max_financial_loss = 500.0
stop_at = 35.54
side = :sell

zero_four_percent_stop = stop_at * (1 - 0.004)
one_percent_stop = stop_at * (1 - 0.01)

puts format_price(max_financial_loss)
puts format_price(stop_at)
puts format_price(zero_four_percent_stop)
puts format_price(one_percent_stop)

average_price = ((zero_four_percent_stop + one_percent_stop - 0.02) / 2).round(2)
position_for_max_financial_loss = min_multiple_of((max_financial_loss / (average_price - stop_at)).abs.to_i, 100)
orders = position_for_max_financial_loss / 100
# position_for_max_financial_loss = min_multiple_of(max_financial_loss / (average_price - stop_at).abs.to_i, 100)

puts position_for_max_financial_loss

cents_in_range = ((one_percent_stop - zero_four_percent_stop) * 100).to_i.abs

puts "Distribute #{orders} orders among #{cents_in_range} cents:"

orders_per_cent = orders / cents_in_range
remaining_orders = orders % cents_in_range
orders_per_cent_map = {}

cents_in_range.times do |cents|
  orders_per_cent_map[(one_percent_stop + cents * 0.01).round(2)] = orders_per_cent
end

if remaining_orders % 2 == 1
  orders_per_cent_map[average_price] += 1
end

(remaining_orders/2).times do |i|
  orders_per_cent_map[(average_price + (i+1) * 0.01).round(2)] += 1
  orders_per_cent_map[(average_price - (i+1) * 0.01).round(2)] += 1
  # puts (average_price + (i+1) * 0.01).round(2)
  # puts (average_price - (i+1) * 0.01).round(2)
end

ap orders_per_cent_map
