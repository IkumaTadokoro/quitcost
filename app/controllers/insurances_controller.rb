# frozen_string_literal: true

class InsurancesController < ApplicationController
  def index; end

  def new
    @insurance_form = InsuranceForm.new
  end

  def create
    @insurance_form = InsuranceForm.new(**insurance_form_params)
    if @insurance_form.save
      redirect_to :insurances, notice: '保険料率を保存しました。'
    else
      render :new
    end
  end

  private

  def insurance_form_params
    params.require(:insurance).permit(
      :year,
      :local_gov_code,
      :medical_income_basis,
      :medical_asset_basis,
      :medical_capita_basis,
      :medical_household_basis,
      :medical_limit,
      :elderly_income_basis,
      :elderly_asset_basis,
      :elderly_capita_basis,
      :elderly_household_basis,
      :elderly_limit,
      :care_income_basis,
      :care_asset_basis,
      :care_capita_basis,
      :care_household_basis,
      :care_limit,
      *InsuranceForm.calendars
    )
  end
end
