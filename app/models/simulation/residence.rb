# frozen_string_literal: true

class Simulation::Residence
  include MonthIterable
  using Simulation::Residence::JuneStartFinancialYear

  BASIC_DEDUCTION = 430_000
  PREFECTURE_CAPITA_BASIS = 1_500
  CITY_CAPITA_BASIS = 3_500
  PREFECTURE_TAX_DEDUCTION = 1_000
  CITY_TAX_DEDUCTION = 1_500
  PREFECTURE_TAX_RATE = 4
  CITY_TAX_RATE = 6
  DUES = [6, 8, 10, 1].freeze
  SPECIAL_COLLECTION_DUES = (1..12).to_a.freeze
  NON_TAXABLE_SALARY_LIMIT = 1_000_000

  def self.calc(param_parser)
    new(param_parser).calc
  end

  def initialize(param_parser)
    @from = param_parser.retirement_month
    @to = param_parser.employment_month
    @salary_table = param_parser.salary_table
    @social_insurance_table = param_parser.social_insurance_table
  end

  def calc
    monthly_residence
  end

  private

  attr_reader :from, :to, :salary_table, :social_insurance_table

  def monthly_residence
    fiscal_years.flat_map do |year|
      unemployed_term = unemployed_term_by_fiscal_year[year]
      payment_completed_term = months_between(from: unemployed_term.first.beginning_of_residence_fy, to: unemployed_term.first)
      payment_target_months = dues(year).select { |month| month >= unemployed_term.first }.presence || [unemployed_term.first]

      unpaid_fee = calc_special_collection(yearly_residence(year)).drop(payment_completed_term.count).sum
      fees_by_month = LocalTaxLaw.calc_installments(unpaid_fee, payment_target_months)

      unemployed_term.map { |month| { month: month, residence: payment_target_months.include?(month) ? fees_by_month.shift : 0 } }
    end
  end

  def dues(year)
    DUES.map { |month| Time.zone.parse("#{month >= 4 ? year : year.next}-#{format('%02d', month)}-01") }
  end

  def calc_special_collection(yearly_residence)
    LocalTaxLaw.calc_installments(yearly_residence, SPECIAL_COLLECTION_DUES)
  end

  def fiscal_years
    unemployed_term.map(&:residence_financial_year).uniq
  end

  def unemployed_term_by_fiscal_year
    unemployed_term.group_by(&:residence_financial_year)
  end

  def unemployed_term
    months_between(from: from, to: to)
  end

  def yearly_residence(year)
    return 0 if salary_table[year] <= NON_TAXABLE_SALARY_LIMIT

    LocalTaxLaw.calc_determined_amount { income_basis(year) + capita_basis }
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
    LocalTaxLaw.calc_tax_base { total_income(year) - income_deduction(year) }
  end

  def total_income(year)
    Simulation::Salary.calc(salary_table[year])
  end

  def income_deduction(year)
    social_insurance_table[year] + BASIC_DEDUCTION
  end
end
