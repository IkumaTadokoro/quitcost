# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Simulation::Insurance, type: :model do
  describe '.calc' do
    subject { Simulation::Insurance.calc(param_parser) }
    let(:param_parser) do
      Simulation::ParamParser.new(
        {
          retirement_month: retirement_month,
          employment_month: employment_month,
          prefecture: '東京都',
          city: '千代田区',
          age: 40,
          simulation_date: simulation_date,
          previous_salary: '5000000',
          salary: '5000000',
          scheduled_salary: '5000000',
          previous_social_insurance: '750000',
          social_insurance: '750000',
          scheduled_social_insurance: '750000'
        }
      )
    end

    context 'when cross the year before employment' do
      let!(:simulation_date) { '2021-04-01' }
      let!(:retirement_month) { '2021-04-01' }
      let!(:employment_month) { '2023-03-01' }

      example '10 term payment(6, 7, 8, 9, 10, 11, 12, 1, 2, 3)' do
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
        expected = [
          { month: Time.zone.parse('2021-04-01'), insurance: 0 },
          { month: Time.zone.parse('2021-05-01'), insurance: 0 },
          { month: Time.zone.parse('2021-06-01'), insurance: 39_200 },
          { month: Time.zone.parse('2021-07-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-08-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-09-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-10-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-11-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-12-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-01-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-02-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-03-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-04-01'), insurance: 0 },
          { month: Time.zone.parse('2022-05-01'), insurance: 0 },
          { month: Time.zone.parse('2022-06-01'), insurance: 39_200 },
          { month: Time.zone.parse('2022-07-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-08-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-09-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-10-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-11-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-12-01'), insurance: 39_100 },
          { month: Time.zone.parse('2023-01-01'), insurance: 39_100 },
          { month: Time.zone.parse('2023-02-01'), insurance: 39_100 }
        ]
        expect(subject).to eq expected
      end

      example '10 term payment(4,5,6,7,8,9,10,11,12,1)' do
        create(
          :insurance,
          :with_payment_target_months,
          months: [4, 5, 6, 7, 8, 9, 10, 11, 12, 1],
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
          months: [4, 5, 6, 7, 8, 9, 10, 11, 12, 1],
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
        expected = [
          { month: Time.zone.parse('2021-04-01'), insurance: 39_200 },
          { month: Time.zone.parse('2021-05-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-06-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-07-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-08-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-09-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-10-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-11-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-12-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-01-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-02-01'), insurance: 0 },
          { month: Time.zone.parse('2022-03-01'), insurance: 0 },
          { month: Time.zone.parse('2022-04-01'), insurance: 39_200 },
          { month: Time.zone.parse('2022-05-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-06-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-07-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-08-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-09-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-10-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-11-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-12-01'), insurance: 39_100 },
          { month: Time.zone.parse('2023-01-01'), insurance: 39_100 },
          { month: Time.zone.parse('2023-02-01'), insurance: 0 }
        ]
        expect(subject).to eq expected
      end

      example '4 term payment(1,7,9,11)' do
        create(
          :insurance,
          :with_payment_target_months,
          months: [1, 7, 9, 11],
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
          months: [1, 7, 9, 11],
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
        expected = [
          { month: Time.zone.parse('2021-04-01'), insurance: 0 },
          { month: Time.zone.parse('2021-05-01'), insurance: 0 },
          { month: Time.zone.parse('2021-06-01'), insurance: 0 },
          { month: Time.zone.parse('2021-07-01'), insurance: 98_000 },
          { month: Time.zone.parse('2021-08-01'), insurance: 0 },
          { month: Time.zone.parse('2021-09-01'), insurance: 97_700 },
          { month: Time.zone.parse('2021-10-01'), insurance: 0 },
          { month: Time.zone.parse('2021-11-01'), insurance: 97_700 },
          { month: Time.zone.parse('2021-12-01'), insurance: 0 },
          { month: Time.zone.parse('2022-01-01'), insurance: 97_700 },
          { month: Time.zone.parse('2022-02-01'), insurance: 0 },
          { month: Time.zone.parse('2022-03-01'), insurance: 0 },
          { month: Time.zone.parse('2022-04-01'), insurance: 0 },
          { month: Time.zone.parse('2022-05-01'), insurance: 0 },
          { month: Time.zone.parse('2022-06-01'), insurance: 0 },
          { month: Time.zone.parse('2022-07-01'), insurance: 98_000 },
          { month: Time.zone.parse('2022-08-01'), insurance: 0 },
          { month: Time.zone.parse('2022-09-01'), insurance: 97_700 },
          { month: Time.zone.parse('2022-10-01'), insurance: 0 },
          { month: Time.zone.parse('2022-11-01'), insurance: 97_700 },
          { month: Time.zone.parse('2022-12-01'), insurance: 0 },
          { month: Time.zone.parse('2023-01-01'), insurance: 97_700 },
          { month: Time.zone.parse('2023-02-01'), insurance: 0 }
        ]
        expect(subject).to eq expected
      end

      example '4 term payment(7,9,10,12)' do
        create(
          :insurance,
          :with_payment_target_months,
          months: [7, 9, 10, 12],
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
          months: [7, 9, 10, 12],
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
        expected = [
          { month: Time.zone.parse('2021-04-01'), insurance: 0 },
          { month: Time.zone.parse('2021-05-01'), insurance: 0 },
          { month: Time.zone.parse('2021-06-01'), insurance: 0 },
          { month: Time.zone.parse('2021-07-01'), insurance: 98_000 },
          { month: Time.zone.parse('2021-08-01'), insurance: 0 },
          { month: Time.zone.parse('2021-09-01'), insurance: 97_700 },
          { month: Time.zone.parse('2021-10-01'), insurance: 97_700 },
          { month: Time.zone.parse('2021-11-01'), insurance: 0 },
          { month: Time.zone.parse('2021-12-01'), insurance: 97_700 },
          { month: Time.zone.parse('2022-01-01'), insurance: 0 },
          { month: Time.zone.parse('2022-02-01'), insurance: 0 },
          { month: Time.zone.parse('2022-03-01'), insurance: 0 },
          { month: Time.zone.parse('2022-04-01'), insurance: 0 },
          { month: Time.zone.parse('2022-05-01'), insurance: 0 },
          { month: Time.zone.parse('2022-06-01'), insurance: 0 },
          { month: Time.zone.parse('2022-07-01'), insurance: 98_000 },
          { month: Time.zone.parse('2022-08-01'), insurance: 0 },
          { month: Time.zone.parse('2022-09-01'), insurance: 97_700 },
          { month: Time.zone.parse('2022-10-01'), insurance: 97_700 },
          { month: Time.zone.parse('2022-11-01'), insurance: 0 },
          { month: Time.zone.parse('2022-12-01'), insurance: 97_700 },
          { month: Time.zone.parse('2023-01-01'), insurance: 0 },
          { month: Time.zone.parse('2023-02-01'), insurance: 0 }
        ]
        expect(subject).to eq expected
      end
    end

    context 'when DO NOT cross the year before employment' do
      context 'when get a job in this financial year' do
        let!(:simulation_date) { '2021-04-01' }
        let!(:retirement_month) { '2021-04-01' }
        let!(:employment_month) { '2022-03-01' }

        example '10 term payment(6,7,8,9,10,11,12,1,2,3)' do
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
          expected = [
            { month: Time.zone.parse('2021-04-01'), insurance: 0 },
            { month: Time.zone.parse('2021-05-01'), insurance: 0 },
            { month: Time.zone.parse('2021-06-01'), insurance: 39_200 },
            { month: Time.zone.parse('2021-07-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-08-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-09-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-10-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-11-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-12-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-01-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-02-01'), insurance: 39_100 }
          ]
          expect(subject).to eq expected
        end

        example '10 term payment(4,5,6,7,8,9,10,11,12,1)' do
          create(
            :insurance,
            :with_payment_target_months,
            months: [4, 5, 6, 7, 8, 9, 10, 11, 12, 1],
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
          expected = [
            { month: Time.zone.parse('2021-04-01'), insurance: 39_200 },
            { month: Time.zone.parse('2021-05-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-06-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-07-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-08-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-09-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-10-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-11-01'), insurance: 39_100 },
            { month: Time.zone.parse('2021-12-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-01-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-02-01'), insurance: 0 }
          ]
          expect(subject).to eq expected
        end

        example '4 term payment(1,7,9,11)' do
          create(
            :insurance,
            :with_payment_target_months,
            months: [1, 7, 9, 11],
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
          expected = [
            { month: Time.zone.parse('2021-04-01'), insurance: 0 },
            { month: Time.zone.parse('2021-05-01'), insurance: 0 },
            { month: Time.zone.parse('2021-06-01'), insurance: 0 },
            { month: Time.zone.parse('2021-07-01'), insurance: 98_000 },
            { month: Time.zone.parse('2021-08-01'), insurance: 0 },
            { month: Time.zone.parse('2021-09-01'), insurance: 97_700 },
            { month: Time.zone.parse('2021-10-01'), insurance: 0 },
            { month: Time.zone.parse('2021-11-01'), insurance: 97_700 },
            { month: Time.zone.parse('2021-12-01'), insurance: 0 },
            { month: Time.zone.parse('2022-01-01'), insurance: 97_700 },
            { month: Time.zone.parse('2022-02-01'), insurance: 0 }
          ]
          expect(subject).to eq expected
        end

        example '4 term payment(7,9,10,12)' do
          create(
            :insurance,
            :with_payment_target_months,
            months: [7, 9, 10, 12],
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
          expected = [
            { month: Time.zone.parse('2021-04-01'), insurance: 0 },
            { month: Time.zone.parse('2021-05-01'), insurance: 0 },
            { month: Time.zone.parse('2021-06-01'), insurance: 0 },
            { month: Time.zone.parse('2021-07-01'), insurance: 98_000 },
            { month: Time.zone.parse('2021-08-01'), insurance: 0 },
            { month: Time.zone.parse('2021-09-01'), insurance: 97_700 },
            { month: Time.zone.parse('2021-10-01'), insurance: 97_700 },
            { month: Time.zone.parse('2021-11-01'), insurance: 0 },
            { month: Time.zone.parse('2021-12-01'), insurance: 97_700 },
            { month: Time.zone.parse('2022-01-01'), insurance: 0 },
            { month: Time.zone.parse('2022-02-01'), insurance: 0 }
          ]
          expect(subject).to eq expected
        end
      end

      context 'when retire and get a job in the next financial year' do
        let!(:simulation_date) { '2021-04-01' }
        let!(:retirement_month) { '2022-04-01' }
        let!(:employment_month) { '2023-03-01' }

        example '10 term payment(6,7,8,9,10,11,12,1,2,3)' do
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
          expected = [
            { month: Time.zone.parse('2022-04-01'), insurance: 0 },
            { month: Time.zone.parse('2022-05-01'), insurance: 0 },
            { month: Time.zone.parse('2022-06-01'), insurance: 39_200 },
            { month: Time.zone.parse('2022-07-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-08-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-09-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-10-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-11-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-12-01'), insurance: 39_100 },
            { month: Time.zone.parse('2023-01-01'), insurance: 39_100 },
            { month: Time.zone.parse('2023-02-01'), insurance: 39_100 }
          ]
          expect(subject).to eq expected
        end

        example '10 term payment(4,5,6,7,8,9,10,11,12,1)' do
          create(
            :insurance,
            :with_payment_target_months,
            months: [4, 5, 6, 7, 8, 9, 10, 11, 12, 1],
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
          expected = [
            { month: Time.zone.parse('2022-04-01'), insurance: 39_200 },
            { month: Time.zone.parse('2022-05-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-06-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-07-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-08-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-09-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-10-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-11-01'), insurance: 39_100 },
            { month: Time.zone.parse('2022-12-01'), insurance: 39_100 },
            { month: Time.zone.parse('2023-01-01'), insurance: 39_100 },
            { month: Time.zone.parse('2023-02-01'), insurance: 0 }
          ]
          expect(subject).to eq expected
        end

        example '4 term payment(1,7,9,11)' do
          create(
            :insurance,
            :with_payment_target_months,
            months: [1, 7, 9, 11],
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
          expected = [
            { month: Time.zone.parse('2022-04-01'), insurance: 0 },
            { month: Time.zone.parse('2022-05-01'), insurance: 0 },
            { month: Time.zone.parse('2022-06-01'), insurance: 0 },
            { month: Time.zone.parse('2022-07-01'), insurance: 98_000 },
            { month: Time.zone.parse('2022-08-01'), insurance: 0 },
            { month: Time.zone.parse('2022-09-01'), insurance: 97_700 },
            { month: Time.zone.parse('2022-10-01'), insurance: 0 },
            { month: Time.zone.parse('2022-11-01'), insurance: 97_700 },
            { month: Time.zone.parse('2022-12-01'), insurance: 0 },
            { month: Time.zone.parse('2023-01-01'), insurance: 97_700 },
            { month: Time.zone.parse('2023-02-01'), insurance: 0 }
          ]
          expect(subject).to eq expected
        end

        example '4 term payment(7,9,10,12)' do
          create(
            :insurance,
            :with_payment_target_months,
            months: [7, 9, 10, 12],
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
          expected = [
            { month: Time.zone.parse('2022-04-01'), insurance: 0 },
            { month: Time.zone.parse('2022-05-01'), insurance: 0 },
            { month: Time.zone.parse('2022-06-01'), insurance: 0 },
            { month: Time.zone.parse('2022-07-01'), insurance: 98_000 },
            { month: Time.zone.parse('2022-08-01'), insurance: 0 },
            { month: Time.zone.parse('2022-09-01'), insurance: 97_700 },
            { month: Time.zone.parse('2022-10-01'), insurance: 97_700 },
            { month: Time.zone.parse('2022-11-01'), insurance: 0 },
            { month: Time.zone.parse('2022-12-01'), insurance: 97_700 },
            { month: Time.zone.parse('2023-01-01'), insurance: 0 },
            { month: Time.zone.parse('2023-02-01'), insurance: 0 }
          ]
          expect(subject).to eq expected
        end
      end
    end

    context 'when Insurance record DOES NOT exist for the target year' do
      let!(:simulation_date) { '2021-04-01' }
      let!(:retirement_month) { '2021-04-01' }
      let!(:employment_month) { '2023-03-01' }

      it 'calculate with fallback record' do
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
        expected = [
          { month: Time.zone.parse('2021-04-01'), insurance: 0 },
          { month: Time.zone.parse('2021-05-01'), insurance: 0 },
          { month: Time.zone.parse('2021-06-01'), insurance: 39_200 },
          { month: Time.zone.parse('2021-07-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-08-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-09-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-10-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-11-01'), insurance: 39_100 },
          { month: Time.zone.parse('2021-12-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-01-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-02-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-03-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-04-01'), insurance: 0 },
          { month: Time.zone.parse('2022-05-01'), insurance: 0 },
          { month: Time.zone.parse('2022-06-01'), insurance: 39_200 },
          { month: Time.zone.parse('2022-07-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-08-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-09-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-10-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-11-01'), insurance: 39_100 },
          { month: Time.zone.parse('2022-12-01'), insurance: 39_100 },
          { month: Time.zone.parse('2023-01-01'), insurance: 39_100 },
          { month: Time.zone.parse('2023-02-01'), insurance: 39_100 }
        ]
        expect(subject).to eq expected
      end
    end
  end
end
