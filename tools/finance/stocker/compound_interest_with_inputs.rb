require_relative './stocker'

# daily_input = 50000 / 30
# profit_ratio = 0.008 * 0.85

# initial = 300000
# current = initial
# desagio = 1
# day = Date.parse('31-01-2022')
# last_day = Date.parse('23-11-2023')

#   # s += ji

# while last_day > day
#   day += 1

#   next if day.saturday? || day.sunday?
#   short = desagio * current * profit_ratio
#   puts "#{day}: #{format_price(current)}, short: #{format_price(short)}, input: #{format_price(daily_input)}"

#   current = (current + short + daily_input) # * (1 - 0.005)
# end

# monthly_input = 50000
# profit_ratio = 0.08 * 0.85

# initial = 300000
# current = initial
# desagio = 1
# month = Date.parse('01-01-2022')
# last_month = Date.parse('23-11-2023')

#   # s += ji

# while last_month > month
#   month += 1.month

#   short = desagio * current * profit_ratio
#   puts "#{month}: #{format_price(current)}, short: #{format_price(short)}, input: #{format_price(monthly_input)}"

#   current = (current + short + monthly_input) # * (1 - 0.005)
# end

weekly_input = (14000 * 0.9 * 5.2 - 10000) / 4.3
profit_ratio = 0.03 * 0.85

initial = 400000
current = initial
desagio = 1
week = Date.parse('01-01-2022')
last_week = Date.parse('23-11-2023')

  # s += ji

while last_week > week
  week += 1.week

  short = desagio * current * profit_ratio
  puts "#{week}: #{format_price(current - 1000000)}, short: #{format_price(short)}, input: #{format_price(weekly_input)}"

  current = (current + short + weekly_input) # * (1 - 0.005)
end
