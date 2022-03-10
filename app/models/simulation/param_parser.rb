# frozen_string_literal: true

class Simulation::ParamParser
  attr_reader :retirement_month, :employment_month, :prefecture, :city, :age, :local_gov_code, :salary_table, :social_insurance_table

  def initialize(params)
    @retirement_month = Time.zone.parse(params[:retirement_month])
    @employment_month = Time.zone.parse(params[:employment_month])
    @age = params[:age].to_i
    @local_gov_code = build_local_gov_code(params)
    @salary_table = build_salary_table(params)
    @social_insurance_table = build_social_insurance_table(params)
  end

  private

  def build_local_gov_code(params)
    JpLocalGov.where(prefecture: params[:prefecture], city: params[:city]).first.code
  end

  def build_salary_table(params)
    base_fiscal_year = base_fiscal_year(params)
    {
      base_fiscal_year.pred => params[:previous_salary].to_i || 0,
      base_fiscal_year => params[:salary].to_i || 0,
      base_fiscal_year.next => params[:scheduled_salary].to_i || 0
    }
  end

  def build_social_insurance_table(params)
    base_fiscal_year = base_fiscal_year(params)
    {
      base_fiscal_year.pred => params[:previous_social_insurance].to_i || 0,
      base_fiscal_year => params[:social_insurance].to_i || 0,
      base_fiscal_year.next => params[:scheduled_social_insurance].to_i || 0
    }
  end

  def base_fiscal_year(params)
    Time.zone.parse(params[:simulation_date]).financial_year
  end
end
