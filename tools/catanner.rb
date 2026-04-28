count_map = Hash.new(0)
total = 0

(1..6).each do |i|
  (1..6).each do |j|
    value = i + j
    total += 1
    count_map[value] += 1
  end
end

prob_map = Hash.new(0)

count_map.each do |value, count|
  prob_map[value] = (count * 100.0 / total).round(2)
end

ball_map = {}

count_map.to_a.reject do |pair|
  pair[0] == 7
end.sort_by do |pair|
  pair[1]
end.each do |pair|
  ball_map[pair[0]] = pair[1]
end

ball_map[0] = 0

puts "ball_map: #{ball_map}"

value_map = {}
ball_value_map = {}

(0..12).each do |i|
  (0..12).each do |j|
    (0..12).each do |k|
      next if i == 7 || j == 7 || k == 7
      next if i == 1 || j == 1 || k == 1

      ijk = [i, j, k].sort

      value_key = ijk.join('-')
      ball_value_key = ijk.map do |l|
        ball_map[l]
      end.sort.join('-')

      value_map[value_key] = [i, j, k].map do |land_number|
        prob_map[land_number]
      end.sum

      ball_value_map[ball_value_key] = value_map[value_key]
    end
  end
end

only_different = true

ball_value_map.to_a.sort_by do |pair|
  pair[1]
end.reverse.each do |pair|
  next if only_different && pair[0].split('-').map(&:to_i).uniq.count < 3
  puts "#{pair[0]}: #{pair[1]}"
end

# by_value = {}

# value_map.each do |pair|
#   puts "#{pair.first}: #{pair[1]}"
# end

# value_map.to_a.sort_by do |pair|
#   pair[1]
# end.reverse.each do |pair|
#   by_value[pair[1]] ||= []
#   by_value[pair[1]].push pair[0]
# end

# if ARGV.any?
#   puts '--------'
#   queries = {}

#   ARGV.select do |query|
#     query =~ /\d+-\d+-\d+/
#   end.map do |query|
#     query.split('-').map(&:to_i).sort.join('-')
#   end.each do |query|
#     queries[query] = value_map[query]
#   end

#   queries.to_a.sort_by do |pair|
#     pair[1]
#   end.reverse.to_h.each do |pair|
#     puts "#{pair[0]}: #{pair[1]}"
#   end
# end


# # by_value.each do |value, combs|
# #   puts "\n#{value.round(2)} ---------"
# #   puts combs.join(',')
# # end
