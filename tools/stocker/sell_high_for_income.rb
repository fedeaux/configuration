require_relative './stocker'

def dy_wallet_sell_profit_ratio_to_target_income_fii_v(
      dy_wallet:,
      dy_wallet_growth:,
      fii_dy:,
      dy_dy:,
      target_income:
    )

  fii_wallet = 42000
  fii_montly_dy = fii_dy / 12
  dy_montly_dy = dy_dy / 12
  dy_wallet_sell_profit_ratio = 0.05

  60.times do |i|
    sell_profit = dy_wallet * dy_wallet_sell_profit_ratio * 0.85
    fii_earnings = fii_wallet * fii_montly_dy
    dy_earnings = dy_wallet * dy_montly_dy

    fii_wallet += sell_profit + fii_earnings + dy_earnings
    dy_wallet += dy_wallet_growth
    dy_wallet = 1_000_000 if dy_wallet > 1_000_000

    puts "Month: #{i}"
    puts "  Fii Earnings: #{fii_earnings}"
    puts "  Sell Profit: #{sell_profit}"
    puts "  Fii Wallet: #{fii_wallet}"
    puts "  Dy Wallet: #{dy_wallet}"
    puts ""

    if fii_earnings > target_income
      break
    end
  end
end

def sell_high_for_income(
      wallet:,
      monthly_input:,
      monthly_dy:,
      dy_wallet_sell_profit_ratio:,
      months: 12
    )

  months.times do |i|
    sell_profit = wallet * dy_wallet_sell_profit_ratio * 0.85
    earnings = wallet * monthly_dy

    wallet += sell_profit + earnings + monthly_input

    puts "Month: #{i}"
    puts "  Sell Profit: #{format_price(sell_profit)}"
    puts "  Earnings: #{format_price(earnings)}"
    puts "  Wallet: #{format_price(wallet)}"
    puts ""
  end
end

sell_high_for_income(
  months: 24,
  wallet: 350_000,
  monthly_input: 60_000,
  monthly_dy: 0.07/12,
  dy_wallet_sell_profit_ratio: 0.035
)
