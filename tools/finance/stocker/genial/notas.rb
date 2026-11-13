require 'pdf-reader'
require_relative '../stocker.rb'

class Wallet
  def initialize
    stocks = {}
  end
end

class Operation
  attr_accessor :code, :nature, :count, :price, :total, :date

  def initialize(code, nature, count, price, total, date)
    self.code = code
    self.nature = nature.downcase.to_sym
    self.count = count.gsub(/[^\d]/, '').to_i
    self.price = parse_money(price)
    self.total = parse_money(total)
    self.date = date
  end

  def sortable_date
    unless @sortable_date
      parts = self.date.split('/')
      @sortable_date = [parts[2], parts[1], parts[0]].join '/'
    end

    @sortable_date
  end
end

class Consolidation
  attr_accessor :key, :code, :date, :total_buy, :total_sell, :count_buy, :count_sell, :closed_operations

  def initialize(key, code, date)
    self.key = key
    self.code = code
    self.date = date
    reset

    self.closed_operations = []
  end

  def reset
    self.total_buy = 0
    self.count_buy = 0
    self.total_sell = 0
    self.count_sell = 0
  end

  def operate(operation)
    if operation.nature == :v
      self.count_sell += operation.count
      self.total_sell += operation.total
    else
      self.count_buy += operation.count
      self.total_buy += operation.total
    end

    # self.check_closes
  end

  def result
    self.total_sell - self.total_buy
  end

  def f_result
    format_price self.result
  end

  def human_result
    "#{self.code}: #{f_result} S:#{format_price(self.total_sell)} - B:#{format_price(self.total_buy)}"
  end

  def check_closes
    return unless self.closed?

    self.closed_operations.push human_result
    reset
  end

  def closed?
    self.count_buy == self.count_sell
  end

  def sortable_date
    unless @sortable_date
      parts = self.date.split('/')
      @sortable_date = [parts[2], parts[1], parts[0]].join '/'
    end

    @sortable_date
  end

  def costs
    (self.total_buy + self.total_sell) * 0.0275 / 100
  end

  def f_costs
    format_price costs
  end

  def f_results_with_costs
    format_price(self.result - self.costs)
  end

  def f_total_sell
    format_price self.total_sell
  end

  def f_total_buy
    format_price self.total_buy
  end

  def f_average_sell
    format_price self.total_sell / self.count_sell
  end

  def f_average_buy
    return 0 if self.count_buy == 0
    format_price self.total_buy / self.count_buy
  end

  def to_csv
    [self.sortable_date, self.code, self.f_average_sell, self.f_average_buy, self.f_total_sell, self.f_total_buy, self.f_result, self.f_costs, self.f_results_with_costs].join ';'
  end
end

class DayBalance
  attr_accessor :date, :sell, :buy

  def initialize(date)
    self.date = date
    self.sell = 0
    self.buy = 0
  end

  def balance
    sell - buy
  end

  def f_balance
    format_price balance
  end

  def sortable_date
    unless @sortable_date
      parts = self.date.split('/')
      @sortable_date = [parts[2], parts[1], parts[0]].join '/'
    end

    @sortable_date
  end
end

def file2json(filename)
  reader = PDF::Reader.new("#{__dir__}/notas/#{filename}.pdf")
  operations = []

  reader.pages.each do |page|
    text = page.text
    date = text.match(/\d\d\/\d\d\/\d\d\d\d/)[0].to_s.strip

    text.split("\n").each do |line|
      line.strip!

      next unless line.start_with? '1-BOVESPA'
      # next unless line[70..-1].strip[0] == 'D'

      nature = line[13]
      code = line[30..60].strip.split(/\s\s\s/).first

      count, price, total = line[92..].split(/\s\s/).reject do |part|
        part.length == 0
      end.compact.map(&:strip)

      operations.push([code, nature, count, price, total, date])
    end
  end

  operations
end

def file2operations(filename)
  cache_file = "#{__dir__}/notas/#{filename}.json"

  if !File.exists?(cache_file)
    File.open(cache_file, 'w') do |f|
      f.write file2json(filename).to_json
    end
  end

  operations = {}

  JSON.parse(File.read cache_file).map do |params|
    operation = Operation.new(params[0], params[1], params[2], params[3], params[4], params[5])
    key = "#{operation.date}: #{operation.code}"
    operations[key] ||= []
    operations[key].push operation
  end

  operations
end

def files2operations
  operations = {}

  # ['2022-02', '2022-03', '2022-04'].each do |filename|
  ['2023-03'].each do |filename|
    operations.merge!(file2operations(filename))
  end

  operations
end

def files2consolidation
  consolidation = {}

  files2operations.each do |key, operations|
    unless consolidation[key]
      consolidation[key] = Consolidation.new(key, operations.first.code, operations.first.date)
    end

    operations.each do |operation|
      consolidation[key].operate operation
    end
  end

  consolidation
end

def files2day_balance
  total_buy = 0
  total_sell = 0

  balance_per_day = {}

  files2operations.values.flatten.sort_by(&:date).each do |operation|
    balance_per_day[operation.date] ||= DayBalance.new(operation.date)
    day_balance = balance_per_day[operation.date]

    if operation.nature == :v
      total_sell += operation.total
      day_balance.sell = day_balance.sell + operation.total
    else
      total_buy += operation.total
      day_balance.buy = day_balance.buy + operation.total
    end
  end

  balance_per_day
end

def files_to_taxes_json(filename)
  cache_file = "#{__dir__}/notas/#{filename}-taxes.json"

  unless File.exists?(cache_file)
    costs_by_date = {}
    latest_date = nil
    total_costs = 0
    operations_value = 0
    total_value = 0
    dates = 0
    genial_lixo_proxima_linha = false

    reader = PDF::Reader.new("#{__dir__}/notas/#{filename}.pdf")

    reader.pages.each do |page|
      text = page.text
      next unless text.include? 'Valor líquido das operações'

      date = text.match(/\d\d\/\d\d\/\d\d\d\d/)[0].to_s.strip

      if latest_date != date
        if latest_date
          costs_by_date[latest_date] = {
            operations_value: operations_value / 100.0,
            total_value: total_value / 100.0,
            total_costs: total_costs / 100.0
          }
        end

        latest_date = date
      end

      text.split("\n").each do |line|
        if line.include? 'Valor líquido das operações'
          important_part = line.split('Valor líquido das operações').last.strip

          operations_value = important_part.gsub(/[^\d]/, '').to_i

          if important_part.last == 'D'
            operations_value = -1 * operations_value
          end
        elsif line.include? 'Liquidação pelo Bruto'
          important_part = line.last(30).strip
          genial_lixo_total_value = important_part.gsub(/[^\d]/, '').to_i

          if genial_lixo_total_value != 0
            total_value = genial_lixo_total_value

            if important_part.last == 'D'
              total_value = -1 * total_value
            end
          end
        elsif line.include? 'Líquido para'
          important_part = line.last(30).strip
          genial_lixo_total_value = important_part.gsub(/[^\d]/, '').to_i

          if genial_lixo_total_value != 0
            total_value = genial_lixo_total_value

            if important_part.last == 'D'
              total_value = -1 * total_value
            end
          end
        end
      end

      total_costs = total_value - operations_value
    end

    costs_by_date[latest_date] = {
      operations_value: operations_value / 100.0,
      total_value: total_value / 100.0,
      total_costs: total_costs / 100.0
    }

    costs_by_date

    File.open(cache_file, 'w') do |f|
      f.write costs_by_date.to_json
    end
  end

  JSON.parse(File.read cache_file)
end

def files2taxes
  costs_by_date = {}

  ['2023-03'].each do |filename|
    costs_by_date.merge! files_to_taxes_json filename
  end

  costs_by_month = {}

  costs_by_date.each do |date, values|
    month = date.split('/').last(2).join('/')
    costs_by_month[month] ||= 0
    costs_by_month[month] += values['total_costs']
  end

  costs_by_month
  costs_by_date.values.map do |v|
    v['total_costs']
  end.sum
end

tp files2consolidation
# files2operations.values.each do |operations|
#   operations.each do |operation|
#     ap operation
#   end
# end
# # tp files2operations.values.flatten.sort_by(&:sortable_date), :date, :code, :total

# ap files2day_balance

# balances = files2day_balance
# tp balances.values.sort_by(&:sortable_date).reverse, :date, :f_balance

# f2c = files2consolidation.values.sort_by(&:sortable_date)

# f2c.each do |consolidation|
#   next unless consolidation.closed?

#   puts consolidation.to_csv
# end

# nil

# profits = f2c.select(&:closed?).select { |c| c.result >= 0 }
# losses = f2c.select(&:closed?).select { |c| c.result < 0 }

# puts "Good"
# tp profits, :date, :code, :f_result
# puts format_price(profits.map(&:result).sum)
# puts "\nBad"
# tp losses, :date, :code, :f_result
# puts format_price(losses.map(&:result).sum)

# puts "\nTotal"
# puts format_price(f2c.select(&:closed?).map(&:result).sum)

# {
#     "01/02/2022" => -69.94,
#     "02/02/2022" => -59.78,
#     "03/02/2022" => -51.27,
#     "04/02/2022" => -154.87,
#     "07/02/2022" => -732.21,
#     "08/02/2022" => -453.5,
#     "09/02/2022" => -205.67,
#     "10/02/2022" => -158.5,
#     "11/02/2022" => -177.76,
#     "14/02/2022" => -12.87,
#     "15/02/2022" => -300.06,
#     "17/02/2022" => -667.0,
#     "18/02/2022" => -256.83,
#     "21/02/2022" => -489.57,
#     "22/02/2022" => -1825.11,
#     "23/02/2022" => -8951.78,
#     "24/02/2022" => -1980.12,
#     "02/03/2022" => -293.55,
#     "03/03/2022" => -2670.87,
#     "04/03/2022" => -2598.62,
#     "07/03/2022" => -450.22,
#     "08/03/2022" => -24595.06,
#     "09/03/2022" => -838.9,
#     "10/03/2022" => -919.88,
#     "11/03/2022" => -4532.15,
#     "14/03/2022" => -1125.0,
#     "15/03/2022" => -178.8,
#     "16/03/2022" => -523.77,
#     "17/03/2022" => -9826.34,
#     "18/03/2022" => -110.15,
#     "21/03/2022" => -479.86,
#     "22/03/2022" => -1080.61,
#     "23/03/2022" => -1484.87,
#     "24/03/2022" => -1400.37,
#     "25/03/2022" => -3.39,
#     "28/03/2022" => -15.65,
#     "30/03/2022" => -150.93,
#     "01/04/2022" => -402.87,
#     "04/04/2022" => -3725.0,
#     "05/04/2022" => -1486.92,
#     "06/04/2022" => -1122.67,
#     "07/04/2022" => 5630.24,
#     "08/04/2022" => -2054.06,
#     "11/04/2022" => -1094.16,
#     "12/04/2022" => -1620.74,
#     "13/04/2022" => -935.29,
#     "14/04/2022" => -1847.99,
#     "18/04/2022" => -3307.17,
#     "19/04/2022" => -1118.68,
#     "20/04/2022" => -1.53
# }
