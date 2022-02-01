# frozen_string_literal: true

FactoryBot.define do
  factory :pention do
    sequence(:year, 2000)
    contribution { rand(0..30_000) }
  end
end
