require_relative './stocker'

new_input_csv = '/Users/fedorius/Downloads/statusinvest-busca-avancada.csv'
inputs_dir = "#{__dir__}/fiinder"
`mkdir -p #{inputs_dir}`

if File.exists?(new_input_csv)
  move_to = "#{inputs_dir}/status-invest-#{Date.current.to_s}.csv"
  `mv #{new_input_csv} #{move_to}`
end

capitalizo_wallet = File.read("#{__dir__}/fiinder/capitalizo-2022-02.txt").split("\n").each_slice(2).map do |line|
  line[1].split('(').last.split(')').first
end

class Fii < OpenStruct
  attr_reader :dy_score, :pvp_score, :dy_cagr_score,
              :n_dy, :n_pvp, :n_dy_cagr,
              :n_dy_score, :n_pvp_score, :n_dy_cagr_score

  def set_metrics(dy_metric, pvp_metric, dy_cagr_metric)
    @dy_score = (dy - dy_metric.min) / dy_metric.sd
    @dy_cagr_score = (dy_cagr - dy_cagr_metric.min) / dy_cagr_metric.sd
    @pvp_score = (pvp_metric.max - pvp) / pvp_metric.sd

    @n_dy = dy_metric.normalize dy
    @n_pvp = pvp_metric.normalize pvp
    @n_dy_cagr = dy_cagr_metric.normalize dy_cagr

    @n_dy_score = n_dy / dy_metric.n_sd
    @n_pvp_score = (1.0 - n_pvp) / pvp_metric.n_sd
    @n_dy_cagr_score = n_dy_cagr / dy_cagr_metric.n_sd
  end

  def score
    # @score ||= @dy_score * @dy_score * @pvp_score * @dy_cagr_score
    @score ||= 1.5 * @dy_score + @pvp_score + @dy_cagr_score
  end

  def n_score
    @n_score ||= 1.5 * @n_dy_score + @n_pvp_score + @n_dy_cagr_score
  end
end

class Metric
  def initialize(corpus)
    @corpus = corpus
  end

  def min
    @min ||= @corpus.min
  end

  def max
    @max ||= @corpus.max
  end

  def avg
    @avg ||= @corpus.sum / @corpus.count
  end

  def normalize(item)
    (item - min) / (max - min)
  end

  def n_corpus
    @normalized ||= @corpus.map(&method(:normalize))
  end

  def n_avg
    @n_avg ||= n_corpus.sum / n_corpus.count
  end

  def sd
    unless @sd
      sum = @corpus.sum(0.0) { |item| (item - avg) ** 2 }
      variance = sum / (@corpus.count - 1)
      @sd = Math.sqrt variance
    end

    @sd
  end

  def n_sd
    unless @n_sd
      sum = n_corpus.sum(0.0) { |item| (item - n_avg) ** 2 }
      variance = sum / (n_corpus.count - 1)
      @n_sd = Math.sqrt variance
    end

    @n_sd
  end
end

input_file = `ls #{inputs_dir}`.split("\n").last

blacklist = [
  'RBBV11', # Fii mentiroso
  'BBFI11B', # Muito arriscado
  'OUFF11',
  'GCFF11', # Muito papel
  'RBCO11', # Mei ruim
]

fiis = File.read("#{inputs_dir}/#{input_file}").split("\n")[1..-1].map do |line|
  attributes = line.split ';'

  Fii.new(
    ticker: attributes[0],
    pvp: attributes[3].gsub(',', '.').to_f,
    dy: attributes[2].gsub(',', '.').to_f,
    dy_cagr: attributes[7].gsub(',', '.').to_f
  )
end.reject do |fii|
  blacklist.include? fii.ticker
end

dy = Metric.new(fiis.map(&:dy))
pvp = Metric.new(fiis.map(&:pvp))
dy_cagr = Metric.new(fiis.map(&:dy_cagr))

fiis.each do |fii|
  fii.set_metrics(dy, pvp, dy_cagr)
end

n_score_metric = Metric.new(fiis.map(&:n_score))

fiis.each do |fii|
  fii.final_score = n_score_metric.normalize(fii.n_score) / n_score_metric.n_sd
end

puts "n_score_metric: #{n_score_metric.avg}, #{n_score_metric.sd}"

top_ten = fiis.sort_by(&:final_score).reverse
tp top_ten, :ticker, :pvp, :dy, :dy_cagr, :final_score

tt_dy = Metric.new(top_ten.map(&:dy))
puts "Top10 dy: #{tt_dy.avg/12}"

# tp fiis.sort_by(&:pvp_score).first(10), :ticker, :pvp, :n_pvp, :pvp_score, :n_pvp_score, :dy, :dy_cagr, :score
# puts "\n"
# tp fiis.sort_by(&:n_pvp_score).first(10), :ticker, :pvp, :n_pvp, :pvp_score, :n_pvp_score, :dy, :dy_cagr, :n_score


#
# puts "pvp: #{pvp.avg} / #{pvp.sd}"
