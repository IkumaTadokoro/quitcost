# frozen_string_literal: true

class Api::InsurancesController < ApplicationController
  def index
    @insurances = Insurance.preload(:payment_target_months)
                           .order(:year)
                           .order(:local_gov_code)
                           .all
                           .page(params[:page])
  end
end
