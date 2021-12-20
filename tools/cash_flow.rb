total_spent = File.readlines('./cash_flow').map do |line|
  puts '-------------'
  puts line[0...10]
  cents = line.split(/\s/).last.strip.gsub('.', '').gsub(',', '').to_i
  puts cents
  cents
end.sum / 100.0

total_now = 226533.15
cash_from_sales = 17200

puts "TOTAL SPENT: #{total_spent}"

diff = total_now - total_spent - cash_from_sales

puts "PROFIT: #{diff} #{diff*100/total_spent}"
