require_relative './stocker'

def list_buy_price_options(input_amount:, min_position_delta:, min_price:)
  current_delta = 0
  current_price = 812903

  while current_price > min_price do
    current_delta += min_position_delta
    current_price = input_amount / current_delta

    puts "Buy #{current_delta} at #{format_price(current_price)}"
  end
end

# TUPY3
list_buy_price_options(
  input_amount: 4800,
  min_position_delta: 100,
  min_price: 15
)
