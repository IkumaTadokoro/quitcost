# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Admin::Simulations', type: :request do
  describe 'GET /api/simulations?q' do
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
