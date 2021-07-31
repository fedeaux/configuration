def total_after_n_months(montly, dy, months)
  r = 0

  (0..months - 1).each do |exponent|
    r += (dy ** exponent)
  end

  montly * r
end

def report(montly, dy, months)
  final = total_after_n_months(montly, dy, months)
  base_dy = dy - 1
  passive_income = final * base_dy

  puts "------------------------"
  puts "#{montly} for #{months} months at #{(base_dy * 100)}%"
  puts "#{passive_income} / month"
end

report(68000, 121.0/120, 30)
report(68000, 126.0/125, 54)
# report(60000, 121.0/120, 30)
# report(60000, 121.0/120, 42)
# report(60000, 121.0/120, 54)
