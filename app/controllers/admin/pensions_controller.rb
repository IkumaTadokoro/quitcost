# frozen_string_literal: true

class Admin::PensionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pension, only: %i[edit update]

  def index; end

  def new
    @pension = Pension.new
  end

  def create
    @pension = Pension.new(pension_params)
    if @pension.save
      redirect_to %i[admin pensions], notice: '保険料率を保存しました。'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @pension.update(pension_params)
      redirect_to %i[admin pensions], notice: '保険料率を更新しました。'
    else
      render :edit
    end
  end

  private

  def set_pension
    @pension = Pension.find(params[:id])
  end

  def pension_params
    params.require(:pension).permit(:year, :contribution)
  end
end
