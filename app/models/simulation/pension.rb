# frozen_string_literal: true

class Simulation::Pension
  include MonthIterable

  def self.calc(param_parser)
    new(param_parser).call
  end

  def initialize(param_parser)
    @from = param_parser.retirement_month
    @to = param_parser.employment_month
  end

  def call
    calculate_pension
  end

  private

  attr_reader :from, :to

  def calculate_pension
    months = months_between(from: from, to: to)
    fiscal_years = months.map(&:financial_year).uniq
    contribution_table = fiscal_years.index_with do |year|
      query = Pension.exists?(year: year) ? year : Pension.maximum(:year)
      Pension.find_by(year: query).contribution
    end

    months.map { |month| { month: month, pension: contribution_table[month.financial_year] } }
  end
end
