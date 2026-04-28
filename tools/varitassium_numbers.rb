totals = []

40000.times do
  total = 1.0

  100.times do |i|
    if rand(2) == 0
      total = total * 1.1
    else
      total = total * 0.9
    end
  end

  totals.push total
end

puts totals.sum / totals.count
