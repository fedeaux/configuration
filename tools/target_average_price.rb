def format_price(price)
  "R$%0.2f" % price
end

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
  position_delta = - current_position

  while position_delta <= current_position
    position_delta += min_position_delta
    current_target_position = current_position + position_delta

    next if current_target_position.zero?

    operation_price = find_operation_target_price(
      current_position: current_position,
      current_average_price: current_average_price,
      target_position: current_target_position,
      target_average_price: target_average_price
    )

    operation_market_value = operation_price * position_delta
    new_market_value = current_target_position * target_average_price

    verb = position_delta.positive? ? "buy" : "sell"

    puts "#{verb} #{position_delta.abs} at #{format_price(operation_price)} (CASH: #{format_price(- operation_market_value)}, ML: #{format_price(new_market_value)})"
  end
end

# PSSA3
list_operation_target_price_options(
  current_position: 2100,
  current_average_price: 21.13,
  target_average_price: 20.92,
)

# CSMG3
puts list_operation_target_price_options(
       current_position: 1600,
       current_average_price: 13.74,
       target_average_price: 12.76,
     )

# WIZS3
puts list_operation_target_price_options(
       current_position: 3000,
       current_average_price: 7.77,
       target_average_price: 7.47,
     )

# ITSA4
puts list_operation_target_price_options(
       current_position: 4000,
       current_average_price: 9.58,
       target_average_price: 9.52,
     )
