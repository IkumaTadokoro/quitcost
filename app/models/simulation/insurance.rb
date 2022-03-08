# frozen_string_literal: true

class Simulation::Insurance
  include MonthIterable

  def self.calc(param_parser)
    new(param_parser).calc
  end

  def initialize(param_parser)
    @from = param_parser.retirement_month
    @to = param_parser.employment_month
    @local_gov_code = param_parser.local_gov_code
    @age = param_parser.age
    @salary_table = param_parser.salary_table
  end

  def calc
    monthly_insurance
  end

  private

  attr_reader :from, :to, :local_gov_code, :age, :salary_table

  def monthly_insurance
    yearly_insurance.flat_map do |year, fee|
      payment_target_months = build_payment_target_month(year)
      payment_terms = payment_terms_by_fiscal_year[year]
      number_of_payment_duty = months_between(from: payment_terms.first, to: payment_terms.first.end_of_financial_year).count
      total_fee = fee * number_of_payment_duty / PaymentTargetMonth::CALENDAR.count
      target_months_in_range = payment_target_months.intersection(payment_terms.map(&:beginning_of_month))
      remain_dues = payment_target_months.select { |month| month >= payment_terms.first }
      fees_by_month = LocalTaxLaw.calc_installments(total_fee, remain_dues, municipal_ordinance: true)

      payment_terms.map do |month|
        insurance = target_months_in_range.include?(month) ? fees_by_month.shift : 0
        { month: month, insurance: insurance }
      end
    end
  end

  def yearly_insurance
    result = {}
    fiscal_years.map do |year|
      salary = salary_table[year]
      result[year] = LocalTaxLaw.calc_determined_amount { calculate_medical(year, salary) + calculate_elderly(year, salary) + calculate_care(year, salary) }
    end
    result
  end

  def build_payment_target_month(year)
    months = Insurance.rate(year: year, local_gov_code: local_gov_code).payment_target_months.map(&:month)
    diff = year - months.first.financial_year
    diff.zero? ?  months : months.map { |month| month.advance(years: diff) }
  end

  def fiscal_years
    all_payment_terms.map(&:financial_year).uniq
  end

  def payment_terms_by_fiscal_year
    all_payment_terms.group_by(&:financial_year)
  end

  def all_payment_terms
    months_between(from: from, to: to)
  end

  def calculate_medical(year, salary)
    Simulation::Insurance::Medical.calc(year: year, local_gov_code: local_gov_code, income: salary, age: age)
  end

  def calculate_elderly(year, salary)
    Simulation::Insurance::Elderly.calc(year: year, local_gov_code: local_gov_code, income: salary, age: age)
  end

  def calculate_care(year, salary)
    Simulation::Insurance::Care.calc(year: year, local_gov_code: local_gov_code, income: salary, age: age)
  end
end
