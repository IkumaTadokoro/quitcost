# frozen_string_literal: true

class Simulation::Insurance
  include MonthIterable

  def self.calc(parameter)
    new(parameter).calc
  end

  def initialize(parameter)
    @from = parameter.retirement_month
    @to = parameter.employment_month
    @local_gov_code = parameter.local_gov_code
    @age = parameter.age
    @salary_table = parameter.salary_table
  end

  def calc
    monthly_insurance
  end

  private

  def monthly_insurance
    yearly_insurance.flat_map do |year, fee|
      unemployed_term = unemployed_term_by_fiscal_year[year]
      subscription_term = months_between(from: unemployed_term.first, to: unemployed_term.first.end_of_financial_year)
      payment_target_months = build_payment_target_month(year).select { |month| month >= unemployed_term.first }

      actual_fee = fee * subscription_term.count / PaymentTargetMonth::CALENDAR.count
      fees_by_payment_target_month = LocalTaxLaw.calc_installments(actual_fee, payment_target_months, municipal_ordinance: true)

      unemployed_term.map do |month|
        { month: month, insurance: payment_target_months.include?(month) ? fees_by_payment_target_month.shift : 0 }
      end
    end
  end

  def yearly_insurance
    result = {}
    fiscal_years.each do |year|
      salary = @salary_table[year]
      result[year] = LocalTaxLaw.calc_determined_amount { calc_medical(year, salary) + calc_elderly(year, salary) + calc_care(year, salary) }
    end
    result
  end

  def build_payment_target_month(year)
    months = Insurance.rate(year: year, local_gov_code: @local_gov_code).payment_target_months.map(&:month)
    diff = year - months.first.financial_year
    diff.zero? ?  months : months.map { |month| month.advance(years: diff) }
  end

  def fiscal_years
    unemployed_term.map(&:financial_year).uniq
  end

  def unemployed_term_by_fiscal_year
    unemployed_term.group_by(&:financial_year)
  end

  def unemployed_term
    months_between(from: @from, to: @to).map(&:beginning_of_month)
  end

  def calc_medical(year, salary)
    Simulation::Insurance::Medical.calc(year: year, local_gov_code: @local_gov_code, income: salary, age: @age)
  end

  def calc_elderly(year, salary)
    Simulation::Insurance::Elderly.calc(year: year, local_gov_code: @local_gov_code, income: salary, age: @age)
  end

  def calc_care(year, salary)
    Simulation::Insurance::Care.calc(year: year, local_gov_code: @local_gov_code, income: salary, age: @age)
  end
end
