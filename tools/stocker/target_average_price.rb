require_relative './stocker'

# Finds the operation price I need to execute to change my current position while
# landing on a new average price
def find_operation_target_price(current_position:, current_average_price:, target_position:, target_average_price:)
  position_delta = target_position - current_position

  target_market_value = target_average_price * target_position
  current_market_value = current_average_price * current_position

  (target_market_value - current_market_value) / position_delta
end

# puts find_operation_target_price(
#   current_position: 2100,
#   current_average_price: 21.13,
#   target_position: 1500,
#   target_average_price: 21.01
# )

def find_new_average_price(current_position:, current_average_price:, position_delta:, operation_price:)
  new_position = current_position + position_delta
  current_market_value = current_average_price * current_position
  market_operation_value = position_delta * operation_price

  new_market_value = current_market_value + market_operation_value
  new_market_value / new_position
end

# puts find_new_average_price(
#        current_position: 2100,
#        current_average_price: 21.13,
#        position_delta: -600,
#        operation_price: 21.91,
#      )

def list_operation_target_price_options(current_position:, current_average_price:, target_average_price:, min_position_delta: 100)
  position_delta = - current_position - min_position_delta
  operation_target_price_options = []

  while position_delta <= current_position
    position_delta += min_position_delta
    current_target_position = current_position + position_delta

    next if position_delta.zero?

    operation_price = find_operation_target_price(
      current_position: current_position,
      current_average_price: current_average_price,
      target_position: current_target_position,
      target_average_price: target_average_price
    )

    operation_market_value = operation_price * position_delta
    new_market_value = current_target_position * target_average_price

    verb = position_delta.positive? ? "buy" : "sell"

    operation_target_price_options.push({ text: "#{verb} #{position_delta.abs} at #{format_price(operation_price)} (CASH: #{format_price(- operation_market_value)}, ML: #{format_price(new_market_value)})", price: round_price(operation_price), nature: 'target-average-price', position_delta: position_delta })
  end

  operation_target_price_options.sort_by! do |operation_target_price_option|
    operation_target_price_option[:price]
  end

  # .map do |operation_target_price_option|
    # operation_target_price_option[:text]
  # end.join "\n"

  operation_target_price_options
end

def list_sell_profit_price_options(current_position:, current_average_price:)
  base_profit_margin = 0.01
  sell_profit_price_options = []

  10.times do |i|
    profit_margin = base_profit_margin * i
    operation_price = round_price((1 + profit_margin) * current_average_price)
    operation_market_value = operation_price * current_position
    profit = (operation_price - current_average_price) * current_position

    sell_profit_price_options.push({ text: "Sell at #{format_price(operation_price)} (CASH: #{format_price(operation_market_value)}, PROFIT: #{format_price(profit)})", detail: format_percentage(profit_margin), price: round_price(operation_price), nature: 'sell-target-price' })
  end

  sell_profit_price_options
end

def spread_fishing(position_delta:, min_price:, max_price:, min_position_delta: 100)
  price_range = max_price - min_price
  max_orders = position_delta / min_position_delta

  orders_by_price_range = max_orders / (price_range * 100)

  puts "orders_by_price_range #{orders_by_price_range}"

  current_price = max_price

  while current_price >= min_price
    puts "#{min_position_delta} @ #{current_price}"
    current_price -= 0.01
  end
end

def rm(value, multiple)
  (value / multiple).to_i * multiple
end

def list_cashout_options(current_position:, target_operation_value: nil, min_position_delta: 100)
  position_delta = current_position
  cashout_options = []

  while position_delta > 0
    target_price = target_operation_value.to_f / position_delta
    message = "Sell #{position_delta} at #{target_price}"
    puts message

    cashout_options.push({ message: message })
    position_delta -= min_position_delta
  end
end

# Buy more ITSA4 and then sell to get to 8.85 average
# puts buy_more_and_then_sell_to_get_to_target_price_options(current_position: 4800, current_average_price: 9.11, target_average_price: 8.85, buy_price: 8.75, max_operation_market_value: 20_000)

# Buy more ITSA4 and then sell to get to 8.85 average
# puts buy_more_and_then_sell_to_get_to_target_price_options(current_position: 4800, current_average_price: 9.11, target_average_price: 8.85, buy_price: 8.75, max_operation_market_value: 20_000)

# Sell 13k worth of ITSA4
# puts list_cashout_options(current_position: 4800, target_operation_value: 13_000)

json = {}

# PSSA3
json['PSSA3'] = list_operation_target_price_options(
  current_position: 2100,
  current_average_price: 21.13,
  target_average_price: 20.92,
)

json['PSSA3'] = list_sell_profit_price_options(
  current_position: 2100,
  current_average_price: 21.13,
)

# CSMG3
json['CSMG3'] = list_operation_target_price_options(
  current_position: 800,
  current_average_price: 13.74,
  target_average_price: 12.76,
)

# BBAS3
json['BBAS3'] = list_operation_target_price_options(
  current_position: 1200,
  current_average_price: 28.78,
  target_average_price: 27.50,
)

# WIZS3
json['WIZS3'] = list_operation_target_price_options(
  current_position: 3000,
  current_average_price: 7.77,
  target_average_price: 7.47,
)

json['WIZS3'] = list_sell_profit_price_options(
  current_position: 3000,
  current_average_price: 7.77,
)

# ITSA4
json['ITSA4'] = list_operation_target_price_options(
  current_position: 4800,
  current_average_price: 9.11,
  target_average_price: 8.89,
)

# BBAS3
json['BBAS3'] = list_operation_target_price_options(
  current_position: 1200,
  current_average_price: 28.68,
  target_average_price: 27.50,
)

# TAEE11
json['TAEE11'] = list_operation_target_price_options(
  current_position: 800,
  current_average_price: 36.92,
  target_average_price: 36.0,
)

json['CPLE6'] = list_operation_target_price_options(
  current_position: 19000,
  current_average_price: 6.08,
  target_average_price: 5.91,
)

# puts json['PSSA3']
# puts json.to_json

# fuck = json['CPLE6'].map do |operation_target_price_option|
#   operation_target_price_option[:text]
# end.join "\n"

# puts fuck

# puts find_operation_target_price(current_position: 2400, current_average_price: 6.27, target_position: 18000, target_average_price: 5.91)
# puts find_new_average_price(current_position: 2400, current_average_price: 6.27, position_delta: 19000 - 2400, operation_price: 6.05)

# json.slice('PSSA3', 'WIZS3').each do |code, operation_target_price_options|
#   operation_target_price_options.each do |operation_target_price_option|
#     puts [code, operation_target_price_option[:price], operation_target_price_option[:nature], operation_target_price_option[:detail], '',operation_target_price_option[:text]].join ';'
#   end
# end

# Fish CPLE6
# spread_fishing(
#   min_price: 6.01,
#   max_price: 6.19,
#   position_delta: 5700
# )

# TODO
def souvenir_trading_options(stock_code:, current_position:, current_average_price:, target_average_price:, enter_price: nil, operation_market_value: nil, min_position_delta: 100)
  position_delta = min_multiple_of(operation_market_value / enter_price, min_position_delta)

  new_average_price = find_new_average_price(current_position: current_position, current_average_price: current_average_price, position_delta: position_delta, operation_price: enter_price)

  result = [
    "Buy #{position_delta} #{stock_code} at #{format_price(enter_price)} (#{format_price(enter_price * position_delta)}) for a new average of #{format_price(new_average_price)}"
  ]

  result.concat(list_operation_target_price_options(
                  current_position: current_position + position_delta,
                  current_average_price: new_average_price,
                  target_average_price: target_average_price,
                ).select do |operation_target_price_option|
                  operation_target_price_option[:price] > (enter_price * 1.025) && operation_target_price_option[:position_delta] > - position_delta
                end.map do |operation_target_price_option|
                  final_position = current_position + position_delta + operation_target_price_option[:position_delta]

                  operation_target_price_option[:text] + " - keep #{final_position} (#{format_price(final_position * target_average_price)})"
                end).join "\n"
end

souvenir_trading_options(
  stock_code: 'BBAS3',
  current_position: 1800,
  current_average_price: 28.79,
  target_average_price: 27.50,
  enter_price: 30.33,
  operation_market_value: 50000
)

souvenir_trading_options(
  stock_code: 'CPLE6',
  current_position: 2600,
  current_average_price: 6.27,
  target_average_price: 5.91,
  enter_price: 6.11,
  operation_market_value: 120000
)

souvenir_trading_options(
  stock_code: 'CSMG3',
  current_position: 1900,
  current_average_price: 13.06,
  target_average_price: 11.17,
  enter_price: 11.52,
  operation_market_value: 90000
)

puts souvenir_trading_options(
  stock_code: 'AURA33',
  current_position: 50,
  current_average_price: 45.37,
  target_average_price: 40,
  enter_price: 41,
  operation_market_value: 120000,
  min_position_delta: 1
)

souvenir_trading_options(
  stock_code: 'VBBR3',
  current_position: 0,
  current_average_price: 0,
  target_average_price: 17.49,
  enter_price: 18.95,
  operation_market_value: 100000
)

# fuck = json['BBAS3'].map do |operation_target_price_option|
#   operation_target_price_option[:text]
# end.join "\n"

# TAEE11
# find_operation_target_price(current_position: 800, current_average_price: 36.92, target_position: 2000, target_average_price: 35.99)

# CPLE6
# find_operation_target_price(current_position: 2600, current_average_price: 6.27, target_position: 16000, target_average_price: 6.18)

# AURA33
# find_operation_target_price(current_position: 2600, current_average_price: 6.27, target_position: 16000, target_average_price: 6.18)

puts find_operation_target_price(current_position: 120000, current_average_price: 11.75, target_position: 150000, target_average_price: 11.80)
