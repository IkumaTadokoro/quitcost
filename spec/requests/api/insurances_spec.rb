# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Insurances', type: :request do
  describe 'GET /api/insurances/index' do
    it 'returns http success' do
      get api_insurances_path(format: :json)
      expect(response).to have_http_status(:success)
    end
  end
end
