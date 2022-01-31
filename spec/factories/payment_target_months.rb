# frozen_string_literal: true

FactoryBot.define do
  factory :payment_target_month do
    month { Time.current.beginning_of_month }
    insurance
  end
end
