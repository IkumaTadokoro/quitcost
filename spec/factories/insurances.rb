# frozen_string_literal: true

FactoryBot.define do
  factory :insurance do
    sequence(:year, 2000)
    local_gov_code { JpLocalGov::Random.code }
    medical_income_basis { rand(0.00..100.00).round(2) }
    medical_asset_basis { rand(0.00..100.00).round(2) }
    medical_capita_basis { rand(0..100_000) }
    medical_household_basis { rand(0..100_000) }
    medical_limit { rand(0..100_000) }
    elderly_income_basis { rand(0.00..100.00).round(2) }
    elderly_asset_basis { rand(0.00..100.00).round(2) }
    elderly_capita_basis { rand(0..100_000) }
    elderly_household_basis { rand(0..100_000) }
    elderly_limit { rand(0..100_000) }
    care_income_basis { rand(0.00..100.00).round(2) }
    care_asset_basis { rand(0.00..100.00).round(2) }
    care_capita_basis { rand(0..100_000) }
    care_household_basis { rand(0..100_000) }
    care_limit { rand(0..100_000) }

    trait(:with_payment_target_months) do
      transient do
        months { PaymentTargetMonth::CALENDAR.values }
      end

      after(:create) do |insurance, evaluator|
        insurance.payment_target_months = evaluator.months.map do |month|
          year = month >= PaymentTargetMonth::CALENDAR[:april] ? insurance.year : insurance.year.next
          build(:payment_target_month, month: Time.zone.parse("#{year}-#{format('%02d', month)}-01"))
        end
      end
    end
  end
end
