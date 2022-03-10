# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email)    { |n| "test#{n}@example.com" }
    sequence(:password) { |n| "password#{n}" }
  end
end
