# frozen_string_literal: true

class Simulation::Parameter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :local_gov_code, :salary_table, :social_insurance_table

  attribute :simulation_date, :time
  attribute :retirement_month, :time
  attribute :employment_month, :time
  attribute :prefecture, :string
  attribute :city, :string
  attribute :age, :integer
  attribute :previous_salary, :integer
  attribute :previous_social_insurance, :integer
  attribute :salary, :integer
  attribute :social_insurance, :integer
  attribute :scheduled_salary, :integer
  attribute :scheduled_social_insurance, :integer

  def initialize(params)
    super(parse_dates!(params))
    @local_gov_code = build_local_gov_code
    @salary_table = build_salary_table
    @social_insurance_table = build_social_insurance_table
  end

  with_options presence: true do
    validates :retirement_month
    validates :employment_month
    validates :local_gov_code
    validates :age
  end

  validates :age, numericality: { greater_than_or_equal_to: 0 }
  validates :retirement_month, comparison: { greater_than: :simulation_date }
  validates :employment_month, comparison: { greater_than: :retirement_month }
  validates :previous_salary, comparison: { greater_than_or_equal_to: :previous_social_insurance }
  validates :salary, comparison: { greater_than: :social_insurance }
  validates :scheduled_salary, comparison: { greater_than_or_equal_to: :scheduled_social_insurance }
  validates_with RequiredSalaryAndSocialInsuranceValidator

  private

  # ActiveSupport::TimeWithZoneを前提にした処理設計になっているが、
  # ActiveModel::Attributesの型キャストにサポートがないため、型キャストが実行される前に一度変換を実施する
  def parse_dates!(params)
    date_attributes = %i[simulation_date retirement_month employment_month]
    date_attributes.each { |attribute| params[attribute] = Time.zone.parse(params[attribute]) }
    params
  end

  def build_local_gov_code
    JpLocalGov.where(prefecture: prefecture, city: city).first.code
  end

  def build_salary_table
    {
      base_fiscal_year.pred => previous_salary,
      base_fiscal_year => salary,
      base_fiscal_year.next => scheduled_salary
    }
  end

  def build_social_insurance_table
    {
      base_fiscal_year.pred => previous_social_insurance,
      base_fiscal_year => social_insurance,
      base_fiscal_year.next => scheduled_social_insurance
    }
  end

  def base_fiscal_year
    simulation_date.financial_year
  end
end
