# frozen_string_literal: true

class API::Admin::PensionsController < API::Admin::BaseController
  def index
    @pensions = Pension.order(year: :desc).all.page(params[:page])
  end

  def destroy
    pension = Pension.find(params[:id])
    pension.destroy
    render status: :ok, json: { message: 'Deleted the Pension', data: pension }
  end
end
