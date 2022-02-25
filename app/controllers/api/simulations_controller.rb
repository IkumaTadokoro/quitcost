# frozen_string_literal: true

class Api::SimulationsController < ApplicationController
  def show
    @simulation = Simulation.new(simulation_params)
  end

  private

  def simulation_params
    params.permit(
      :retirement_month,
      :employment_month,
      :prefecture,
      :city,
      :age,
      :simulation_date,
      :salary,
      :scheduled_salary,
      :social_insurance,
      :scheduled_social_insurance
    )
  end
end
