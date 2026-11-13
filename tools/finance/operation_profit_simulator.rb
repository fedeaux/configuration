require 'ostruct'
require 'awesome_print'

operation_outcome_distribution = [
  { result: -4.5, operations: 15 },
  { result: -0.5, operations: 15 },
  { result: 0.5, operations: 15 },
  { result: 5, operations: 55 },
].map do |operation_outcome|
  OpenStruct.new operation_outcome
end

def eval_average_result(operation_outcome_distribution, n = 100)
  total_operations = operation_outcome_distribution.map(&:operations).sum

  average_gain = operation_outcome_distribution.map do |operation_outcome|
    operation_outcome.result.to_f * operation_outcome.operations
  end.sum / total_operations

  (((1 + average_gain/100.0) ** n) * 10).to_i / 10.0
end

def stochastic_result(operation_outcome_distribution, n = 100)
  start_cash = 10000.0
  current_cash = start_cash
  broker_fees = 0.6 / 100.0

  tax_rate = 15 / 100.0

  cumulative_distribution_map = []
  cumulative_probability = 0.0

  total_operations = operation_outcome_distribution.map(&:operations).sum

  operation_outcome_distribution.each do |operation_outcome|
    cumulative_probability += operation_outcome.operations.to_f / total_operations

    cumulative_distribution_map.push(
      OpenStruct.new(cumulative_probability: cumulative_probability, result: operation_outcome.result / 100.0)
    )
  end

  n.times do |i|
    your_destiny = rand

    result = cumulative_distribution_map.find do |distribution_entry|
      distribution_entry.cumulative_probability >= your_destiny
    end.result

    current_cash *= (1.0 - broker_fees + result)
  end

  profit = (current_cash - start_cash) * (1.0 - tax_rate)

  ((profit / start_cash) * 10).to_i / 10.0
end

def average_stochastic_results(operation_outcome_distribution, n, k = n)
  k.times.map do
    stochastic_result(operation_outcome_distribution, n)
  end.sum / k
end

puts "#{eval_average_result operation_outcome_distribution, 200}x"
# puts "#{stochastic_result(operation_outcome_distribution, 100)}x"
puts "#{4.0/7*100}%"
puts "#{average_stochastic_results(operation_outcome_distribution, 200)}x"
# puts "#{stochastic_result(operation_outcome_distribution, 300)}x"
# puts "#{stochastic_result(operation_outcome_distribution, 400)}x"
