# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists

class Simulation::Insurance
  def self.call(retirement_month, employment_month, local_gov_code, age, simulation_date, salary, scheduled_salary)
    new(retirement_month, employment_month, local_gov_code, age, simulation_date, salary, scheduled_salary).call
  end

  def initialize(retirement_month, employment_month, local_gov_code, age, simulation_date, salary, scheduled_salary)
    @from = retirement_month
    @to = employment_month
    @local_gov_code = local_gov_code
    @age = age
    @simulation_date = simulation_date
    @salary = salary
    @scheduled_salary = scheduled_salary
  end

  def call
    monthly_insurance
  end

  private

  attr_reader :from, :to, :local_gov_code, :age, :simulation_date, :salary, :scheduled_salary

  def monthly_insurance
    yearly_insurance.flat_map do |year, fee|
      payment_target_months = Insurance.rate(year: year, local_gov_code: local_gov_code).payment_target_months
      payment_terms = payment_terms_by_fiscal_year[year]
      number_of_payment_duty = months_between(from: payment_terms.first, to: payment_terms.first.end_of_financial_year).count
      total_fee = fee * number_of_payment_duty / PaymentTargetMonth::CALENDAR.count
      target_months_in_range = payment_target_months.map(&:month).intersection(payment_terms.map(&:beginning_of_month))
      remain_dues = payment_target_months.select { |month| month.month >= payment_terms.first }
      fees_by_month = calculate_fees_by_month(total_fee, remain_dues.count)

      payment_terms.map do |month|
        insurance = target_months_in_range.include?(month) ? fees_by_month.shift : 0
        { month: month, insurance: insurance }
      end
    end
  end

  def months_between(from:, to:)
    Enumerator.produce(from, &:next_month).take_while { |date| date < to }
  end

  def yearly_insurance
    result = {}
    fiscal_years.map do |year|
      salary = salary_table[year]
      result[year] = calculate_medical(year, salary) + calculate_elderly(year, salary) + calculate_care(year, salary)
    end
    result
  end

  # NOTE: 前提：フォームで入力可能な「就職月」は`現在日付の会計年度 + 1 の 末月`まで
  # NOTE: 計算可能な範囲を拡張する場合には、このテーブルに前提に記載の月以降の給与をセットする必要がある
  def salary_table
    base_fiscal_year = simulation_date.financial_year
    {
      base_fiscal_year => salary,
      base_fiscal_year + 1 => scheduled_salary
    }
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
    Simulation::Insurance::Medical.call(year: year, local_gov_code: local_gov_code, income: salary, age: age)
  end

  def calculate_elderly(year, salary)
    Simulation::Insurance::Elderly.call(year: year, local_gov_code: local_gov_code, income: salary, age: age)
  end

  def calculate_care(year, salary)
    Simulation::Insurance::Care.call(year: year, local_gov_code: local_gov_code, income: salary, age: age)
  end

  def calculate_fees_by_month(total_fee, number_of_payments)
    repeat_number = number_of_payments - 1
    fee_of_not_first_month = (total_fee / number_of_payments).floor(-2)
    fee_of_first_month = total_fee - fee_of_not_first_month * repeat_number
    [fee_of_first_month, Array.new(repeat_number) { fee_of_not_first_month }].flatten
  end
end

# rubocop:enable Metrics/ParameterLists
