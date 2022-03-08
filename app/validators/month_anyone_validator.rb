# frozen_string_literal: true

class MonthAnyoneValidator < ActiveModel::Validator
  def validate(record)
    months = PaymentTargetMonth::CALENDAR.each_value.map { |num| record.send("month#{num}") }
    return if months.any?

    record.errors.add(:payment_target_months, '納付対象月は最低1つチェックしてください')
  end
end
