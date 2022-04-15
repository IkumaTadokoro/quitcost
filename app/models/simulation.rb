# frozen_string_literal: true

class Simulation
  CATEGORY = %i[insurance pension residence].freeze

  def initialize(parameter)
    @parameter = parameter
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
    @parameter.retirement_month
  end

  def employment_month
    @parameter.employment_month
  end

  private

  def insurance
    Simulation::Insurance.calc(@parameter)
  end

  def pension
    Simulation::Pension.calc(@parameter)
  end

  def residence
    Simulation::Residence.calc(@parameter)
  end
end
