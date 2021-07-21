received_usd = 8641.33
taxable_usd = 8333.33
received_brl = 44012.38
ir_tax = 0.275
jur_ir_tax = 0.12
monthly_expenses_brl = 8000.0

exchange_rate = received_brl / received_usd
taxable_brl = taxable_usd * exchange_rate
brl_taxes = taxable_brl * ir_tax
able_mine = received_brl - brl_taxes
dy = 1/150.0
investment = able_mine - monthly_expenses_brl

puts "ABLE:"
puts "Total: R$ #{received_brl}"
puts "Taxable: R$ #{taxable_brl}"
puts "Non-Taxable: R$ #{received_brl - taxable_brl} / USD #{received_usd - taxable_usd}"
puts "Taxes: R$ #{brl_taxes}"
puts "MINE: #{able_mine}"
puts "INV: #{investment}"
# puts "DY/M: #{investment * dy}"
# puts "DY in 3 years: #{investment * dy * 36}"
# puts "DY in 4 years: #{investment * dy * 48}"
puts "------------------------"
puts "INV: #{69523.56 - 12000 - brl_taxes}"

return

# Able @ CNPJ

brl_taxes = received_brl * jur_ir_tax
cnpj_mine = received_brl - brl_taxes
investment = cnpj_mine - monthly_expenses_brl

puts "Able @ CNPJ:"
puts "Total: R$ #{received_brl}"
puts "Taxable: R$ #{received_brl}"
puts "Taxes: R$ #{brl_taxes}"
puts "MINE: #{cnpj_mine}"
puts "INV: #{investment}"
puts "DY/M: #{investment * dy}"
puts "DY in 3 years: #{investment * dy * 36}"
puts "DY in 4 years: #{investment * dy * 48}"
puts "------------------------"

diff = cnpj_mine - able_mine
dividends = diff * dy

puts "diff: R$ #{diff}; R$ #{dividends}/month, R$ #{dividends * 12}/month/year, R$ #{dividends * 48}/month/4 years"

# Find a CNPJ job that pays USD 60/hr

received_usd = 60 * 40 * 4.3
received_brl = received_usd * exchange_rate
brl_taxes = received_brl * jur_ir_tax
cnpj_mine = received_brl - brl_taxes
investment = cnpj_mine - monthly_expenses_brl

puts "CNPJ @ 60/h:"
puts "Total: R$ #{received_brl}"
puts "Taxable: R$ #{received_brl}"
puts "Taxes: R$ #{brl_taxes}"
puts "MINE: #{cnpj_mine}"
puts "INV: #{investment}"
puts "DY/M: #{investment * dy}"
puts "------------------------"

diff = cnpj_mine - able_mine
dividends = diff * dy

puts "diff: R$ #{diff}; R$ #{dividends}/month, R$ #{dividends * 12}/month/year, R$ #{dividends * 48}/month/4 years"

# Find a CNPJ job that pays USD 80/hr

received_usd = 80 * 40 * 4.3
received_brl = received_usd * exchange_rate
brl_taxes = received_brl * jur_ir_tax
cnpj_mine = received_brl - brl_taxes
investment = cnpj_mine - monthly_expenses_brl

puts "CNPJ @ 80/h:"
puts "Total: R$ #{received_brl}"
puts "Taxable: R$ #{received_brl}"
puts "Taxes: R$ #{brl_taxes}"
puts "MINE: #{cnpj_mine}"
puts "INV: #{investment}"
puts "DY/M: #{investment * dy}"
puts "------------------------"

diff = cnpj_mine - able_mine
dividends = diff * dy

puts "diff: R$ #{diff}; R$ #{dividends}/month, R$ #{dividends * 12}/month/year, R$ #{dividends * 48}/month/4 years"
