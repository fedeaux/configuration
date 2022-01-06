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

def dy_wallet_sell_profit_ratio_to_target_wallet(
      wallet:,
      monthly_input:,
      monthly_dy:,
      dy_wallet_sell_profit_ratio:
    )

  12.times do |i|
    sell_profit = dy_wallet * dy_wallet_sell_profit_ratio * 0.85
    earnings = wallet * monthly_dy

    wallet += sell_profit + earnings + monthly_input

    puts "Month: #{i}"
    puts "  Earnings: #{earnings}"
    puts "  Wallet: #{wallet}"
    puts ""
  end
end

dy_wallet_sell_profit_ratio_to_target_income(
  wallet: 350_000,
  monthly_input: 50000,
  montly_dy: 0.09/12,
  dy_walllet_sell_profit_ratio: 0.045
)
