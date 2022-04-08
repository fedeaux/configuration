require_relative './stocker'

def distribute_fishing(min_price:, max_price:, total_input:, min_position_delta: 100)
  cent_steps = ((max_price - min_price) * 100).to_i
  input_per_cent_step = total_input / cent_steps
  leftover_input = total_input

  fishing_regions = {
  }

  cent_steps.times do |cent_step|
    step_price = min_price + cent_step / 100.0
    shares_bought = min_multiple_of(input_per_cent_step / step_price, min_position_delta)
    actually_spent = shares_bought * step_price
    leftover_input -= actually_spent

    fishing_regions[cent_step] = {
      price: step_price,
      shares_bought: shares_bought
    }
  end

  ap leftover_input

  fishing_regions
end

puts distribute_fishing(min_price: 5.91, max_price: 6.01, total_input: 112000 - 16000, min_position_delta: 100)
