sl = ARGV[0].to_f
slp = (ARGV[1] || 2.5).to_f
fr = (ARGV[2] || 1000).to_f

puts "sl.to_f: #{sl.to_f}"
puts "slp: #{slp}"
puts "fr: #{fr}"

financial_position = 100 * fr / slp
entry_price = (sl * (1 - slp/100)).round(2)
volume = (financial_position / entry_price / 100).to_i * 100

puts "financial_position: #{financial_position}"
puts "entry_price: #{entry_price}"
puts "volume: #{volume}"
