# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class Simulation::Residence
  BASIC_DEDUCTION = 430_000
  PREFECTURE_CAPITA_BASIS = 1_500
  CITY_CAPITA_BASIS = 3_500
  PREFECTURE_TAX_DEDUCTION = 1_000
  CITY_TAX_DEDUCTION = 1_500
  PREFECTURE_TAX_RATE = 4
  CITY_TAX_RATE = 6
  DUES = [6, 8, 10, 1].freeze
  NON_TAXABLE_SALARY_LIMIT = 1_000_000

  def self.call(param_parser)
    new(param_parser).call
  end

  def initialize(param_parser)
    @from = param_parser.retirement_month
    @to = param_parser.employment_month
    @salary = param_parser.salary
    @social_insurance = param_parser.social_insurance
    @scheduled_salary = param_parser.scheduled_salary
    @scheduled_social_insurance = param_parser.scheduled_social_insurance
    @simulation_date = param_parser.simulation_date
  end

  def call
    monthly_residence
  end

  private

  attr_reader :from, :to, :salary, :social_insurance, :scheduled_salary, :scheduled_social_insurance, :simulation_date

  def monthly_residence
    fiscal_years.flat_map do |year|
      payment_terms = payment_terms_by_fiscal_year[year]
      beginning_of_terms = payment_terms.first
      elapsed_month = months_between(from: beginning_of_terms.beginning_of_financial_year.next_month.next_month, to: beginning_of_terms)
      unpaid_fee = calc_special_collection(yearly_residence(year)).drop(elapsed_month.count).sum
      remain_dues = DUES.map { |month| convert_time(year, month) }.select { |month| month >= beginning_of_terms }
      due_months = remain_dues.empty? ? [beginning_of_terms] : remain_dues
      fees_by_month = calculate_fees_by_month(unpaid_fee, due_months.count)
      payment_terms.map { |month| { month: month, residence: due_months.include?(month) ? fees_by_month.shift : 0 } }
    end
  end

  def convert_time(year, month)
    Time.zone.parse("#{month >= 4 ? year : year.next}-#{format('%02d', month)}-01")
  end

  def months_between(from:, to:)
    Enumerator.produce(from, &:next_month).take_while { |date| date < to }
  end

  def calc_special_collection(yearly_residence)
    calculate_fees_by_month(yearly_residence, 12)
  end

  def calculate_fees_by_month(total_fee, number_of_payments)
    repeat_number = number_of_payments - 1
    fee_of_not_first_month = (total_fee / number_of_payments).floor(-2)
    fee_of_first_month = total_fee - fee_of_not_first_month * repeat_number
    [fee_of_first_month, Array.new(repeat_number) { fee_of_not_first_month }].flatten
  end

  def fiscal_years
    all_payment_terms.map { |payment_term| payment_term.prev_month.prev_month.financial_year }.uniq
  end

  def payment_terms_by_fiscal_year
    all_payment_terms.group_by { |payment_term| payment_term.prev_month.prev_month.financial_year }
  end

  def all_payment_terms
    months_between(from: from, to: to)
  end

  def yearly_residence(year)
    return 0 if salary_table[year] <= NON_TAXABLE_SALARY_LIMIT

    income_basis(year) + capita_basis
  end

  def income_basis(year)
    income_basis_before_tax_apply(year) - tax_deduction
  end

  def capita_basis
    PREFECTURE_CAPITA_BASIS + CITY_CAPITA_BASIS
  end

  def tax_deduction
    PREFECTURE_TAX_DEDUCTION + CITY_TAX_DEDUCTION
  end

  def income_basis_before_tax_apply(year)
    tax_rates.map { |tax_rate| (taxation_total_income(year) * tax_rate / 100).floor(-2) }.sum
  end

  def tax_rates
    [PREFECTURE_TAX_RATE, CITY_TAX_RATE]
  end

  def taxation_total_income(year)
    (total_income(year) - income_deduction(year)).floor(-3)
  end

  def total_income(year)
    Simulation::Salary.call(salary_table[year])
  end

  def income_deduction(year)
    social_insurance_table[year] + BASIC_DEDUCTION
  end

  def salary_table
    {
      base_fiscal_year => salary,
      base_fiscal_year.next => scheduled_salary
    }
  end

  def social_insurance_table
    {
      base_fiscal_year => social_insurance,
      base_fiscal_year.next => scheduled_social_insurance
    }
  end

  def base_fiscal_year
    simulation_date.financial_year
  end
end

# rubocop:enable Metrics/ClassLength
