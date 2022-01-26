# frozen_string_literal: true

class Api::InsurancesController < ApplicationController
  def index
    @insurances = Insurance.preload(:payment_target_months)
                           .order(:year)
                           .order(:local_gov_code)
                           .all
                           .page(params[:page])
  end

  def destroy
    insurance = Insurance.find(params[:id])
    insurance.destroy
    render status: :ok, json: { id: insurance.id }
  end
end
