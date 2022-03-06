# frozen_string_literal: true

class Simulation
  include ActiveModel::Model
  include ActiveModel::Attributes

  CATEGORY = %i[insurance pension residence].freeze

  def initialize(params)
    @param_parser = ParamParser.new(params)
  end

  def grand_total
    sub_total.values.sum
  end

  def sub_total
    CATEGORY.index_with { |category| monthly_payment.sum { |r| r[:fee][category] } }
  end

  def monthly_payment
    group_by_month = [].concat(insurance, pension, residence).group_by { |simulation| simulation[:month] }
    group_by_month.map do |month, value|
      { month: month, fee: {}.merge(*value.map { |data| data.slice(*CATEGORY) }) }
    end
  end

  def retirement_month
    @param_parser.retirement_month
  end

  def employment_month
    @param_parser.employment_month
  end

  private

  attr_reader :param_parser

  def insurance
    Simulation::Insurance.calc(param_parser)
  end

  def pension
    Simulation::Pension.calc(param_parser)
  end

  def residence
    Simulation::Residence.calc(param_parser)
  end
end
