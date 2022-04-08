require 'pdf-reader'
require_relative '../stocker.rb'

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

  ['2022-02', '2022-03', '2022-04'].each do |filename|
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

# tp files2operations.values.flatten.sort_by(&:sortable_date), :date, :code, :total

# balances = files2day_balance
# tp balances.values.sort_by(&:sortable_date).reverse, :date, :f_balance

f2c = files2consolidation.values.sort_by(&:sortable_date)

f2c.each do |consolidation|
  next unless consolidation.closed?

  puts consolidation.to_csv
end

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
