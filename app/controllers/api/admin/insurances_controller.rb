# frozen_string_literal: true

class API::Admin::InsurancesController < API::Admin::BaseController
  def index
    @insurances = Insurance
                  .preload(:payment_target_months)
                  .order(:year)
                  .order(:local_gov_code)
                  .all
                  .page(params[:page])
  end

  def destroy
    insurance = Insurance.find(params[:id])
    insurance.destroy
    render status: :ok, json: { message: 'Deleted the Insurance', data: insurance }
  end
end
