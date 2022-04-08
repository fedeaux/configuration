require_relative './stocker'

def list_souvenir_trading_options(stock_code:, current_position:, current_average_price:, target_average_price:, enter_price: , market_operation_value_step: 5000, min_position_delta: 100)
  median_position_delta_step = (market_operation_value_step / enter_price).to_i.to_f
  lower_position_delta_step = min_multiple_of(median_position_delta_step, min_position_delta)
  upper_position_delta_step = lower_position_delta_step + min_position_delta

  position_delta_step = if upper_position_delta_step - median_position_delta_step < median_position_delta_step - lower_position_delta_step
                          upper_position_delta_step
                        else
                          lower_position_delta_step
                        end

  puts "#{position_delta_step} #{format_price(position_delta_step * enter_price)}"
end

list_souvenir_trading_options(
  stock_code: 'B3SA3',
  current_position: 0,
  current_average_price: 0,
  target_average_price: 10.0,
  enter_price: 11.85,
)
