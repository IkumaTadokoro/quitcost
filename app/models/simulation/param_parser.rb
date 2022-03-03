# frozen_string_literal: true

class Simulation::ParamParser
  attr_reader :retirement_month, :employment_month, :prefecture, :city, :age, :simulation_date, :salary, :scheduled_salary, :social_insurance,
              :scheduled_social_insurance, :local_gov_code

  def initialize(params)
    @retirement_month = Time.zone.parse(params[:retirement_month])
    @employment_month = Time.zone.parse(params[:employment_month])
    @prefecture = params[:prefecture]
    @city = params[:city]
    @age = params[:age].to_i
    @simulation_date = Time.zone.parse(params[:simulation_date])
    @salary = params[:salary].to_i
    @scheduled_salary = params[:scheduled_salary].to_i
    @social_insurance = params[:social_insurance].to_i
    @scheduled_social_insurance = params[:scheduled_social_insurance].to_i
    @local_gov_code = build_local_gov_code
  end

  private

  def build_local_gov_code
    JpLocalGov.where(prefecture: prefecture, city: city).first.code
  end
end
