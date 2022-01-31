# frozen_string_literal: true

class Insurance < ApplicationRecord
  include JpLocalGov
  jp_local_gov :local_gov_code

  paginates_per 20

  has_many :payment_target_months, dependent: :destroy do
    # 責務的にはPaymentTargetMonthにおいた方がいいと思うが、おそらくCollectionProxyに対する`any?`ではなくなるため、
    # クエリ発行回数が増える。そのため一旦はhas_manyのブロック内で定義する
    PaymentTargetMonth::CALENDAR.each do |month_name, month_num|
      define_method "#{month_name}_is_target?" do
        any? { |row| row.month.month == month_num }
      end
    end
  end

  validates :local_gov_code, presence: true, uniqueness: { scope: :year }
  validate :local_gov_code_must_meet_jis_std

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

  def local_gov_code_must_meet_jis_std
    errors.add(:local_gov_code, 'is not valid code') unless JpLocalGov.valid_code?(local_gov_code)
  end
end
