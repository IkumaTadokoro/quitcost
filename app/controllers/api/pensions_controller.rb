# frozen_string_literal: true

class API::PensionsController < ApplicationController
  def index
    @pensions = Pension.order(:year).all.page(params[:page])
  end

  def destroy
    pension = Pension.find(params[:id])
    pension.destroy
    render status: :ok, json: { id: pension.id }
  end
end
