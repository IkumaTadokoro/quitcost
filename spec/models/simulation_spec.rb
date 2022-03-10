# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation, type: :model do
  describe '#grand_total' do
    it 'returns correct value' do
      create(
        :insurance,
        :with_payment_target_months,
        months: [6, 7, 8, 9, 10, 11, 12, 1, 2, 3],
        year: 2021,
        local_gov_code: '131016',
        medical_income_basis: 7.25,
        medical_capita_basis: 0,
        medical_household_basis: 37_300,
        medical_limit: 630_000,
        elderly_income_basis: 2.04,
        elderly_capita_basis: 0,
        elderly_household_basis: 11_000,
        elderly_limit: 190_000,
        care_income_basis: 1.21,
        care_capita_basis: 0,
        care_household_basis: 14_200,
        care_limit: 170_000
      )
      create(
        :insurance,
        :with_payment_target_months,
        months: [6, 7, 8, 9, 10, 11, 12, 1, 2, 3],
        year: 2022,
        local_gov_code: '131016',
        medical_income_basis: 7.25,
        medical_capita_basis: 0,
        medical_household_basis: 37_300,
        medical_limit: 630_000,
        elderly_income_basis: 2.04,
        elderly_capita_basis: 0,
        elderly_household_basis: 11_000,
        elderly_limit: 190_000,
        care_income_basis: 1.21,
        care_capita_basis: 0,
        care_household_basis: 14_200,
        care_limit: 170_000
      )
      create(:pension, year: 2021, contribution: 16_610)
      create(:pension, year: 2022, contribution: 16_590)

      simulation = Simulation.new(
        {
          retirement_month: '2022-03-01',
          employment_month: '2022-06-01',
          prefecture: '東京都',
          city: '千代田区',
          age: '40',
          simulation_date: '2022-02-11',
          previous_salary: '2_000_000',
          salary: '2_000_000',
          scheduled_salary: '2_000_000',
          previous_social_insurance: '100_000',
          social_insurance: '100_000',
          scheduled_social_insurance: '100_000'
        }
      )
      expect(simulation.grand_total).to eq 80_781
    end
  end

  describe '#sub_total' do
    it 'returns correct value' do
      create(
        :insurance,
        :with_payment_target_months,
        months: [6, 7, 8, 9, 10, 11, 12, 1, 2, 3],
        year: 2021,
        local_gov_code: '131016',
        medical_income_basis: 7.25,
        medical_capita_basis: 0,
        medical_household_basis: 37_300,
        medical_limit: 630_000,
        elderly_income_basis: 2.04,
        elderly_capita_basis: 0,
        elderly_household_basis: 11_000,
        elderly_limit: 190_000,
        care_income_basis: 1.21,
        care_capita_basis: 0,
        care_household_basis: 14_200,
        care_limit: 170_000
      )
      create(
        :insurance,
        :with_payment_target_months,
        months: [6, 7, 8, 9, 10, 11, 12, 1, 2, 3],
        year: 2022,
        local_gov_code: '131016',
        medical_income_basis: 7.25,
        medical_capita_basis: 0,
        medical_household_basis: 37_300,
        medical_limit: 630_000,
        elderly_income_basis: 2.04,
        elderly_capita_basis: 0,
        elderly_household_basis: 11_000,
        elderly_limit: 190_000,
        care_income_basis: 1.21,
        care_capita_basis: 0,
        care_household_basis: 14_200,
        care_limit: 170_000
      )
      create(:pension, year: 2021, contribution: 16_610)
      create(:pension, year: 2022, contribution: 16_590)

      expected = { insurance: 12_991, pension: 49_790, residence: 18_000 }
      simulation = Simulation.new(
        {
          retirement_month: '2022-03-01',
          employment_month: '2022-06-01',
          prefecture: '東京都',
          city: '千代田区',
          age: '40',
          simulation_date: '2022-02-11',
          previous_salary: '2_000_000',
          salary: '2_000_000',
          scheduled_salary: '2_000_000',
          previous_social_insurance: '100_000',
          social_insurance: '100_000',
          scheduled_social_insurance: '100_000'
        }
      )
      expect(simulation.sub_total).to eq expected
    end
  end

  describe '#monthly_payment' do
    it 'returns correct value' do
      create(
        :insurance,
        :with_payment_target_months,
        months: [6, 7, 8, 9, 10, 11, 12, 1, 2, 3],
        year: 2021,
        local_gov_code: '131016',
        medical_income_basis: 7.25,
        medical_capita_basis: 0,
        medical_household_basis: 37_300,
        medical_limit: 630_000,
        elderly_income_basis: 2.04,
        elderly_capita_basis: 0,
        elderly_household_basis: 11_000,
        elderly_limit: 190_000,
        care_income_basis: 1.21,
        care_capita_basis: 0,
        care_household_basis: 14_200,
        care_limit: 170_000
      )
      create(
        :insurance,
        :with_payment_target_months,
        months: [6, 7, 8, 9, 10, 11, 12, 1, 2, 3],
        year: 2022,
        local_gov_code: '131016',
        medical_income_basis: 7.25,
        medical_capita_basis: 0,
        medical_household_basis: 37_300,
        medical_limit: 630_000,
        elderly_income_basis: 2.04,
        elderly_capita_basis: 0,
        elderly_household_basis: 11_000,
        elderly_limit: 190_000,
        care_income_basis: 1.21,
        care_capita_basis: 0,
        care_household_basis: 14_200,
        care_limit: 170_000
      )
      create(:pension, year: 2021, contribution: 16_610)
      create(:pension, year: 2022, contribution: 16_590)

      expected = [
        { month: Time.zone.parse('2022/03/01'), fee: { insurance: 12_991, pension: 16_610, residence: 18_000 } },
        { month: Time.zone.parse('2022/04/01'), fee: { insurance: 0, pension: 16_590, residence: 0 } },
        { month: Time.zone.parse('2022/05/01'), fee: { insurance: 0, pension: 16_590, residence: 0 } }
      ]
      simulation = Simulation.new(
        {
          retirement_month: '2022-03-01',
          employment_month: '2022-06-01',
          prefecture: '東京都',
          city: '千代田区',
          age: '40',
          simulation_date: '2022-02-11',
          previous_salary: '2_000_000',
          salary: '2_000_000',
          scheduled_salary: '2_000_000',
          previous_social_insurance: '100_000',
          social_insurance: '100_000',
          scheduled_social_insurance: '100_000'
        }
      )
      expect(simulation.monthly_payment).to eq expected
    end
  end
end
