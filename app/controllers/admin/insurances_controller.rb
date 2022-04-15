# frozen_string_literal: true

class Admin::InsurancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_insurance, only: %i[edit update]

  def index; end

  def new
    @insurance_form = InsuranceForm.new
    return unless params[:id]

    copy_attribute
  end

  def create
    @insurance_form = InsuranceForm.new(**insurance_form_params)
    if @insurance_form.save
      redirect_to %i[admin insurances], notice: '保険料率を保存しました。'
    else
      render :new
    end
  end

  def edit
    @insurance_form = InsuranceForm.new(@insurance)
  end

  def update
    @insurance_form = InsuranceForm.new(@insurance, **insurance_form_params)
    if @insurance_form.save
      redirect_to %i[admin insurances], notice: '保険料率を更新しました。'
    else
      render :edit
    end
  end

  private

  def set_insurance
    @insurance = Insurance.find(params[:id])
  end

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

  def copy_attribute
    insurance = Insurance.find(params[:id])
    payment_target_months = insurance.payment_target_months.map { _1.month.month }
    @insurance_form.local_gov_code = insurance.local_gov_code
    @insurance_form.medical_income_basis = insurance.medical_income_basis
    @insurance_form.medical_asset_basis = insurance.medical_asset_basis
    @insurance_form.medical_capita_basis = insurance.medical_capita_basis
    @insurance_form.medical_household_basis = insurance.medical_household_basis
    @insurance_form.medical_limit = insurance.medical_limit
    @insurance_form.elderly_income_basis = insurance.elderly_income_basis
    @insurance_form.elderly_asset_basis = insurance.elderly_asset_basis
    @insurance_form.elderly_capita_basis = insurance.elderly_capita_basis
    @insurance_form.elderly_household_basis = insurance.elderly_household_basis
    @insurance_form.elderly_limit = insurance.elderly_limit
    @insurance_form.care_income_basis = insurance.care_income_basis
    @insurance_form.care_asset_basis = insurance.care_asset_basis
    @insurance_form.care_capita_basis = insurance.care_capita_basis
    @insurance_form.care_household_basis = insurance.care_household_basis
    @insurance_form.care_limit = insurance.care_limit
    PaymentTargetMonth::CALENDAR.each_value { |num| @insurance_form.send("month#{num}=", payment_target_months.any? { |month| month == num }) }
  end
end
