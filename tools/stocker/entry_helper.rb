require_relative './stocker.rb'

MAX_LOSS = 1000
STOP_EXECUTION_OFFSET = 0.03

def by_entry_and_stop(entry:, stop:)
  side = if entry > stop
           'buy'
         else
           'sell'
         end

  stop_execution_offset = (side == 'buy' ? -1 * STOP_EXECUTION_OFFSET : STOP_EXECUTION_OFFSET)
  stop_execution = stop + stop_execution_offset
  stop_risk = (stop - entry).abs
  loss_per_share = (entry - stop_execution).abs
  shares = min_multiple_of MAX_LOSS / loss_per_share, 100
  total_entry = shares * entry
  total_loss = loss_per_share * shares
  break_even_trigger = if side == 'buy'
                         entry + loss_per_share
                       else
                         entry - loss_per_share
                       end

  break_even_trigger_percentage = format_percentage((break_even_trigger - entry).abs / entry)
  stop_ratio = (stop - entry).abs / entry
  stop_percentage = format_percentage(stop_ratio)
  one_to_six_target = (side == 'buy' ? entry + stop_risk * 6 : entry - stop_risk * 6)
  one_to_oneone_target = (side == 'buy' ? entry + stop_risk * 1.1 : entry - stop_risk * 1.1)

  # puts "  Entry: #{shares} shares at #{format_price(entry)} (#{format_price(total_entry)}), Stop: #{format_price(stop)}, Max Loss: #{format_price(total_loss)}"
  OpenStruct.new(
    entry: format_price(entry),
    shares: shares,
    break_even: "At #{format_price(break_even_trigger)} (#{break_even_trigger_percentage}) => #{format_price(entry - stop_execution_offset)}",
    one_to_six: format_price(one_to_six_target),
    one_to_one: format_price(one_to_oneone_target),
    stop_ratio: stop_ratio,
    stop: "#{format_price(stop)} (#{stop_percentage})",
    total_entry: format_price(total_entry),
    total_loss: format_price(total_loss),
  )
end

def by_stop(stop:, side: 'buy')
  puts "-- By Stop: #{format_price(stop)} --"
  entry_step = if side == 'sell'
                 -0.01
               else
                 0.01
               end

  current_entry = if side == 'sell'
                    stop - entry_step
                  else
                    stop + entry_step
                  end

  entry_options = 200.times.map do
    current_entry += entry_step

    by_entry_and_stop(entry: current_entry, stop: stop)
  end.select do |entry_option|
    stop_ratio = entry_option[:stop_ratio]

    stop_ratio >= 0.002 && stop_ratio <= 0.02
    true
  end

  tp entry_options, :entry, :shares, :stop, :stop_ratio, :one_to_six, :break_even, :total_entry, :total_loss
end

by_stop stop: parse_money(ARGV[0]), side: ARGV[1] == 'b' ? 'buy' : 'sell'

# price = parse_money(ARGV[0])
# nature = ARGV[1] || 'v'
# target_ratio = 0.01
# stop_ratio = 0.005

# if nature == 'v'
#   target = price * (1 - target_ratio)
#   stop = price * (1 + stop_ratio)
#   puts "Stop: #{format_price(stop)}; Target: #{format_price(target)}"
# else
#   target = price * (1 + target_ratio)
#   stop = price * (1 - stop_ratio)
#   puts "Stop: #{format_price(stop)}; Target: #{format_price(target)}"
# end

# [200000, 400000, 600000, 800000, 1000000, 1200000, 1400000, 1600000, 1800000, 2000000].each do |entry|
#   total = ((entry / price) / 1000).to_i * 1000
#   actual_entry = total * price

#   loss = (actual_entry - stop * total).abs
#   gain = (actual_entry - target * total).abs

#   puts "#{format_price(actual_entry)}: #{total} | L:#{format_price(loss)} ; G:#{format_price(gain)}"
# end
