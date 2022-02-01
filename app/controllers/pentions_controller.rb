# frozen_string_literal: true

class PentionsController < ApplicationController
  before_action :set_pention, only: %i[edit update]

  def index; end

  def new
    @pention = Pention.new
  end

  def create
    @pention = Pention.new(pention_params)
    if @pention.save
      redirect_to :pentions, notice: '保険料率を保存しました。'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @pention.update(pention_params)
      redirect_to :pentions, notice: '保険料率を更新しました。'
    else
      render :edit
    end
  end

  private

  def set_pention
    @pention = Pention.find(params[:id])
  end

  def pention_params
    params.require(:pention).permit(:year, :contribution)
  end
end
