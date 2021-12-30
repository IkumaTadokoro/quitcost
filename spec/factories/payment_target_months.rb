FactoryBot.define do
  factory :payment_target_month do
    month { Time.current.beginning_of_month }
    insurance
  end
end
