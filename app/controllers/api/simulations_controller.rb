# frozen_string_literal: true

class API::SimulationsController < ApplicationController
  before_action :validate_parameter, only: :show

  def show
    @simulation = Simulation.new(parameter)
  end

  private

  def validate_parameter
    return if parameter.valid?

    render json: { 'errors': parameter.errors.full_messages }, status: :bad_request
  end

  def parameter
    @parameter ||= Simulation::Parameter.new(simulation_params)
  end

  def simulation_params
    params.permit(
      :retirement_month,
      :employment_month,
      :prefecture,
      :city,
      :age,
      :simulation_date,
      :previous_salary,
      :salary,
      :scheduled_salary,
      :previous_social_insurance,
      :social_insurance,
      :scheduled_social_insurance
    )
  end
end
