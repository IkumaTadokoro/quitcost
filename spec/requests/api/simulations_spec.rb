# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Admin::Simulations', type: :request do
  describe 'GET /api/simulations?q' do
    before do
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
    end

    context 'when params is valid' do
      it 'returns http ok and expected json' do
        params = {
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
        get api_simulations_path(format: :json), params: params
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)['simulation']
        expect(json.keys).to include('retirement_month', 'employment_month', 'grand_total', 'sub_total', 'monthly_payment')
      end
    end

    context 'when params is NOT valid' do
      it 'returns http bad_request' do
        params = {
          retirement_month: '2022-03-01',
          employment_month: '2022-06-01',
          prefecture: '東京都',
          city: '千代田区',
          age: '40',
          simulation_date: '2022-02-11',
          previous_salary: '',
          salary: '',
          scheduled_salary: '',
          previous_social_insurance: '',
          social_insurance: '',
          scheduled_social_insurance: ''
        }
        get api_simulations_path(format: :json), params: params
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
