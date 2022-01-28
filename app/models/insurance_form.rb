# frozen_string_literal: true

class InsuranceForm # rubocop:disable Metrics/ClassLength
  include ActiveModel::Model
  include ActiveModel::Attributes

  delegate :persisted?, to: :insurance
  attr_reader :insurance

  def initialize(insurance = Insurance.new, **attributes)
    @insurance = insurance
    attributes = default_attributes if attributes.empty?
    super(attributes)
  end

  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :local_gov_code, presence: true
  validate :local_gov_code_must_meet_jis_std
  validate :local_gov_code_and_year_must_be_uniqueness

  with_options numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true } do
    validates :medical_income_basis
    validates :medical_asset_basis
    validates :elderly_income_basis
    validates :elderly_asset_basis
    validates :care_income_basis
    validates :care_asset_basis
  end

  with_options numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true } do
    validates :medical_capita_basis
    validates :medical_household_basis
    validates :medical_limit
    validates :elderly_capita_basis
    validates :elderly_household_basis
    validates :elderly_limit
    validates :care_capita_basis
    validates :care_household_basis
    validates :care_limit
  end

  attribute :year, :integer
  attribute :local_gov_code, :string
  attribute :medical_income_basis, :decimal, default: 0
  attribute :medical_asset_basis, :decimal, default: 0
  attribute :medical_capita_basis, :integer, default: 0
  attribute :medical_household_basis, :integer, default: 0
  attribute :medical_limit, :integer, default: 0
  attribute :elderly_income_basis, :decimal, default: 0
  attribute :elderly_asset_basis, :decimal, default: 0
  attribute :elderly_capita_basis, :integer, default: 0
  attribute :elderly_household_basis, :integer, default: 0
  attribute :elderly_limit, :integer, default: 0
  attribute :care_income_basis, :decimal, default: 0
  attribute :care_asset_basis, :decimal, default: 0
  attribute :care_capita_basis, :integer, default: 0
  attribute :care_household_basis, :integer, default: 0
  attribute :care_limit, :integer, default: 0
  PaymentTargetMonth::CALENDAR.each_value { |n| attribute :"month#{n}", :boolean }

  def save # rubocop:disable Metrics/MethodLength
    return false if invalid?

    ActiveRecord::Base.transaction do # rubocop:disable Metrics/BlockLength
      insurance.update!(
        year: year,
        local_gov_code: local_gov_code,
        medical_income_basis: medical_income_basis,
        medical_asset_basis: medical_asset_basis,
        medical_capita_basis: medical_capita_basis,
        medical_household_basis: medical_household_basis,
        medical_limit: medical_limit,
        elderly_income_basis: elderly_income_basis,
        elderly_asset_basis: elderly_asset_basis,
        elderly_capita_basis: elderly_capita_basis,
        elderly_household_basis: elderly_household_basis,
        elderly_limit: elderly_limit,
        care_income_basis: care_income_basis,
        care_asset_basis: care_asset_basis,
        care_capita_basis: care_capita_basis,
        care_household_basis: care_household_basis,
        care_limit: care_limit
      )
      PaymentTargetMonth::CALENDAR.each_value do |n|
        payment_target_month = PaymentTargetMonth.find_or_initialize_by(
          insurance_id: insurance.id,
          month: Time.zone.parse("#{year}-#{format('%02d', n)}-01")
        )
        if payment_target_month.persisted?
          payment_target_month.destroy! unless send(:"month#{n}")
        elsif send(:"month#{n}")
          payment_target_month.save!
        end
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def to_model
    insurance
  end

  def self.calendars
    PaymentTargetMonth::CALENDAR.values.map { "month#{_1}" }
  end

  private

  def default_attributes
    {
      year: insurance.year,
      local_gov_code: insurance.local_gov_code,
      medical_income_basis: insurance.medical_income_basis,
      medical_asset_basis: insurance.medical_asset_basis,
      medical_capita_basis: insurance.medical_capita_basis,
      medical_household_basis: insurance.medical_household_basis,
      medical_limit: insurance.medical_limit,
      elderly_income_basis: insurance.elderly_income_basis,
      elderly_asset_basis: insurance.elderly_asset_basis,
      elderly_capita_basis: insurance.elderly_capita_basis,
      elderly_household_basis: insurance.elderly_household_basis,
      elderly_limit: insurance.elderly_limit,
      care_income_basis: insurance.care_income_basis,
      care_asset_basis: insurance.care_asset_basis,
      care_capita_basis: insurance.care_capita_basis,
      care_household_basis: insurance.care_household_basis,
      care_limit: insurance.care_limit
    }.merge(payment_target_months_attributes)
  end

  def payment_target_months_attributes
    PaymentTargetMonth::CALENDAR.map do |month, n|
      { "month#{n}".to_sym => insurance.payment_target_months.send("#{month}_is_target?") }
    end.reduce(&:merge)
  end

  def local_gov_code_and_year_must_be_uniqueness
    return unless !insurance.persisted? && Insurance.where(local_gov_code: local_gov_code, year: year).exists?

    errors.add(:local_gov_code, 'に既に登録済みのコードが指定されています。年度を見直してください')
  end

  def local_gov_code_must_meet_jis_std
    errors.add(:local_gov_code, 'に無効な値が設定されています') unless JpLocalGov.valid_code?(local_gov_code)
  end
end
