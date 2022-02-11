# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Pensions', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get api_pensions_path(format: :json)
      expect(response).to have_http_status(:success)
    end
  end
end