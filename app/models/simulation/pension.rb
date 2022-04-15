# frozen_string_literal: true

class Simulation::Pension
  include MonthIterable

  def self.calc(parameter)
    new(parameter).call
  end

  def initialize(parameter)
    @from = parameter.retirement_month
    @to = parameter.employment_month
  end

  def call
    calculate_pension
  end

  private

  def calculate_pension
    months = months_between(from: @from, to: @to)
    fiscal_years = months.map(&:financial_year).uniq
    contribution_table = fiscal_years.index_with do |year|
      query = Pension.exists?(year: year) ? year : Pension.maximum(:year)
      Pension.find_by(year: query).contribution
    end

    months.map { |month| { month: month, pension: contribution_table[month.financial_year] } }
  end
end
