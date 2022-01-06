require_relative './stocker'

class Inputable < HcrxStruct
  # def initialize(attributes)
  #   super
  # end

  def initial_total_position=(value)
    super
    self.current_total_position = initial_total_position
  end

  def adjusted_target_percentage
    target_percentage / total_target_percentages
  end

  def adjusted_percentual_distance_from_balance
    (current_percentage - adjusted_target_percentage) / target_percentage
  end

  alias_method :adb, :adjusted_percentual_distance_from_balance

  def adjusted_current_percentage
    current_position.to_f / current_total_position * total_target_percentages
  end

  def current_percentage
    current_position.to_f / current_total_position
  end

  def human_adjusted_current_percentage
    format_percentage adjusted_current_percentage
  end

  def buy_batch
    self.shares_bought ||= 0
    self.shares_bought += min_batch
    self.current_position += min_batch_price
  end

  def min_batch_price
    min_batch * price
  end

  def total_input_price
    return 0 unless shares_bought

    shares_bought * price
  end

  def savings_by_cent
    return '-' unless shares_bought

    format_price(shares_bought * 0.01)
  end

  def free_batch_price
    return '-' unless shares_bought && total_input_price

    format_price(total_input_price / (shares_bought + min_batch))
  end
end

class Inputer
  attr_accessor :inputables, :initial_total_position, :current_total_position

  def initialize(inputables_attributes: [])
    self.inputables = inputables_attributes.map do |inputable_attributes|
      Inputable.new(inputable_attributes)
    end

    self.initial_total_position = inputables.map(&:current_position).sum
    self.current_total_position = initial_total_position
    total_target_percentages = inputables.map(&:target_percentage).sum

    inputables.each do |inputable|
      inputable.initial_total_position = initial_total_position
      inputable.total_target_percentages = total_target_percentages
    end
  end

  def iterate
    inputable = inputables.sort_by(&:adb).first
    inputable.buy_batch

    self.current_total_position = inputables.map(&:current_position).sum

    inputables.each do |inputable|
      inputable.current_total_position = current_total_position
    end
  end

  def iterate_until_target_input_price(target_input_price:)
    target_position = initial_total_position + target_input_price
    iterate while target_position > current_total_position
  end

  def total_input_price
    inputables.map(&:total_input_price).sum
  end

  def inspect
    puts ""
    tp inputables, :code, :current_position, :shares_bought, :target_percentage, :price, :adjusted_current_percentage, :adb
  end

  def results
    puts format_price(total_input_price)
    tp inputables, :code, :human_adjusted_current_percentage, :shares_bought, :total_input_price, :current_position, :price, :free_batch_price, :savings_by_cent
  end
end

def distribute_inputs(target_input_price:, inputables_attributes: [])
  inputer = Inputer.new(inputables_attributes: inputables_attributes)
  inputer.iterate_until_target_input_price(target_input_price: target_input_price)
  inputer.results
end

distribute_inputs(
  target_input_price: 100000 - 65000,
  inputables_attributes: [
    {
      code: 'TAEE11',
      current_position: 29_540,
      target_percentage: 0.07,
      price: 36,
      min_batch: 100
    },
    # {
    #   code: 'CPLE6',
    #   current_position: 16_287,
    #   target_percentage: 0.08,
    #   price: 6.19,
    #   min_batch: 100
    # },
    {
      code: 'BBAS3',
      current_position: 37479,
      target_percentage: 0.065,
      price: 28.89,
      min_batch: 100
    },
  ]
)
