# frozen_string_literal: true

FactoryBot.define do
  factory :insurance_form do
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
    month1 { false }
    month2 { false }
    month3 { false }
    month4 { false }
    month5 { false }
    month6 { false }
    month7 { false }
    month8 { false }
    month9 { false }
    month10 { false }
    month11 { false }
    month12 { false }

    trait(:all_months_are_target) do
      month1  { true }
      month2  { true }
      month3  { true }
      month4  { true }
      month5  { true }
      month6  { true }
      month7  { true }
      month8  { true }
      month9  { true }
      month10 { true }
      month11 { true }
      month12 { true }
    end
  end
end
