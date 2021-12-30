# frozen_string_literal: true

class Insurance < ApplicationRecord
  include JpLocalGov
  jp_local_gov :local_gov_code

  has_many :payment_target_month

  validates :local_gov_code, presence: true, uniqueness: { scope: :year }
  validate :valid_code?

  with_options numericality: { in: 0.00..100.00 } do
    validates :medical_income_basis
    validates :medical_asset_basis
    validates :elderly_income_basis
    validates :elderly_asset_basis
    validates :care_income_basis
    validates :care_asset_basis
  end

  with_options numericality: { only_integer: true, greater_than_or_equal_to: 0 } do
    validates :year, presence: true
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

  private

  def valid_code?
    errors.add(:local_gov_code, "is not valid code") unless JpLocalGov.valid_code?(local_gov_code)
  end
end
