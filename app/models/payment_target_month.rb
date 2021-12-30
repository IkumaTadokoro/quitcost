# frozen_string_literal: true

class PaymentTargetMonth < ApplicationRecord
  belongs_to :insurance

  validate :valid_code?
  validates :local_gov_code, presence: true
  validates :month, presence: true

  private

  def valid_code?
    errors.add(:local_gov_code, "is not valid code") unless JpLocalGov.valid_code?(local_gov_code)
  end
end
