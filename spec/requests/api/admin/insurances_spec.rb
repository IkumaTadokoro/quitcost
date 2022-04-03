# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Admin::Insurances', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /api/admin/insurances' do
    before { create_list(:insurance, 21) }
    context 'when client sign in as admin' do
      it 'returns http success and insurance json' do
        sign_in user

        get api_admin_insurances_path(format: :json)
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['insurance'].length).to eq(20)
      end
    end

    context 'when client DOES NOT sign in as admin' do
      it 'returns http unauthorized' do
        get api_admin_insurances_path(format: :json)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/admin/insurances/:id' do
    let!(:insurance) { create(:insurance) }
    context 'when client sign in as admin' do
      it 'should delete a record and returns http success' do
        sign_in user
        expect { delete api_admin_insurance_path(insurance.id) }.to change(Insurance, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when client DOES NOT sign in as admin' do
      it 'should NOT delete a record and returns http unauthorized' do
        delete api_admin_insurance_path(insurance.id)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
