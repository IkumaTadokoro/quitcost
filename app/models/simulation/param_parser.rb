# frozen_string_literal: true

class Simulation::ParamParser
  attr_reader :retirement_month, :employment_month, :prefecture, :city, :age, :simulation_date, :salary, :scheduled_salary, :social_insurance,
              :scheduled_social_insurance, :local_gov_code, :salary_table, :social_insurance_table

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
    @salary_table = build_salary_table
    @social_insurance_table = build_social_insurance_table
  end

  private

  def build_local_gov_code
    JpLocalGov.where(prefecture: prefecture, city: city).first.code
  end

  # NOTE: 前提：フォームで入力可能な「就職月」は`現在日付の会計年度 + 1 の 末月`まで
  # NOTE: 計算可能な範囲を拡張する場合には、このテーブルに前提に記載の月以降の給与をセットする必要がある
  def build_salary_table
    {
      base_fiscal_year => salary,
      base_fiscal_year.next => scheduled_salary
    }
  end

  def build_social_insurance_table
    {
      base_fiscal_year => social_insurance,
      base_fiscal_year.next => scheduled_social_insurance
    }
  end

  def base_fiscal_year
    simulation_date.financial_year
  end
end
