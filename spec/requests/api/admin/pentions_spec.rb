# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Admin::Pensions', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /api/admin/pensions' do
    before { create_list(:pension, 21) }
    context 'when client sign in as admin' do
      it 'returns http success and pension json' do
        sign_in user

        get api_admin_pensions_path(format: :json)
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['pensions'].length).to eq(20)
      end
    end

    context 'when client DOES NOT sign in as admin' do
      it 'returns http unauthorized' do
        get api_admin_pensions_path(format: :json)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/pensions/:id' do
    let!(:pension) { create(:pension) }
    context 'when client sign in as admin' do
      it 'should delete a record and returns http success' do
        sign_in user
        expect { delete api_admin_pension_path(pension.id) }.to change(Pension, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when client DOES NOT sign in as admin' do
      it 'should NOT delete a record and returns http unauthorized' do
        delete api_admin_pension_path(pension.id)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
