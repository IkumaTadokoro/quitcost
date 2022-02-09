# frozen_string_literal: true

class Simulation::Pension
  def self.call(retirement_month, employment_month)
    new(retirement_month, employment_month).call
  end

  def initialize(retirement_month, employment_month)
    @from = retirement_month
    @to = employment_month
  end

  def call
    calculate_pension
  end

  private

  attr_reader :from, :to

  def calculate_pension
    months = Enumerator.produce(from, &:next_month).take_while { |date| date < to }
    fiscal_years = months.map(&:financial_year).uniq
    contribution_table = fiscal_years.index_with do |year|
      query = Pension.exists?(year: year) ? year : Pension.maximum(:year)
      Pension.find_by(year: query).contribution
    end

    months.map { |month| { month: month, pension: contribution_table[month.financial_year] } }
  end
end
