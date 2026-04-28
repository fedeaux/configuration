def f(n)
  (n-5).to_f / (n-1).to_f
end

10.times do |n|
  m = f(n)

  puts "n = #{n}, m = #{m} -> #{(m + 5)/(m + 1)}"
end

# stocks = 75100

# while stocks > 0
#   dividends = 15000.0 / stocks

#   if dividends.to_s.split('.').last.length <= 2
#     puts "#{dividends},#{stocks},#{187500.0/stocks}"
#   end

#   stocks -= 100
# end

# value_map = {}

# 6.times do |i|
#   dice_1 = i + 1

#   6.times do |j|
#     dice_2 = j + 1

#     value_map[dice_1 + dice_2] ||= 0
#     value_map[dice_1 + dice_2] += 1
#   end
# end

# puts value_map

# width = 6
# total = 12*12

# 12.times do |i|
#   height = i + 1

#   decks_by_box = width * height

#   boxes = total.to_f / decks_by_box

#   if boxes.to_i == boxes
#     puts "#{boxes} boxes of #{width}x#{height}"
#   end
# end
