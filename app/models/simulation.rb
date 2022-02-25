# frozen_string_literal: true

class Simulation
  include ActiveModel::Model
  include ActiveModel::Attributes

  CATEGORY = %i[insurance pension residence].freeze

  attr_reader :retirement_month, :employment_month

  def initialize(params)
    @retirement_month = Time.zone.parse(params[:retirement_month])
    @employment_month = Time.zone.parse(params[:employment_month])
    @prefecture = params[:prefecture]
    @city = params[:city]
    @age = params[:age].to_i
    @simulation_date = Time.zone.parse(params[:simulation_date])
    @salary = params[:salary].to_i
    @scheduled_salary = params[:scheduled_salary].to_i
    @social_insurance = params[:social_insurance].to_i
    @scheduled_social_insurance = params[:scheduled_social_insurance].to_i
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

  private

  attr_reader :age, :simulation_date, :salary, :scheduled_salary, :social_insurance, :scheduled_social_insurance

  def insurance
    Simulation::Insurance.call(retirement_month, employment_month, local_gov_code, age, simulation_date, salary, scheduled_salary)
  end

  def pension
    Simulation::Pension.call(retirement_month, employment_month)
  end

  def residence
    Simulation::Residence.call(retirement_month, employment_month, salary, social_insurance, scheduled_salary, scheduled_social_insurance, simulation_date)
  end

  def local_gov_code
    JpLocalGov.where(prefecture: @prefecture, city: @city).first.code
  end
end
