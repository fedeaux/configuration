require_relative './stocker'

def distribute_fishing(min_price:, max_price:, total_input:, min_position_delta: 100)
  minimal_min_input = min_position_delta * min_price
  minimal_max_input = min_position_delta * max_price

  # cent_steps = ((max_price - min_price) * 100).to_i
  # input_per_cent_step = total_input / cent_steps
  # leftover_input = total_input

  # fishing_regions = {
  # }

  # cent_steps.times do |cent_step|
  #   step_price = min_price + cent_step / 100.0
  #   shares_bought = min_multiple_of(input_per_cent_step / step_price, min_position_delta)
  #   actually_spent = shares_bought * step_price
  #   leftover_input -= actually_spent

  #   fishing_regions[cent_step] = {
  #     price: step_price,
  #     shares_bought: shares_bought
  #   }
  # end

  # puts "leftover_input: #{leftover_input}"

  # fishing_regions
end

fishing_regions = distribute_fishing(min_price: 8.90, max_price: 9.80, total_input: (200 - 99)*1000, min_position_delta: 1000)
fishing_regions.values.each do |fishing_region|
  puts "#{fishing_region[:shares_bought]}: #{number_to_currency(fishing_region[:price])}"
end
