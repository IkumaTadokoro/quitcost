# frozen_string_literal: true

class PentionsController < ApplicationController
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

  private

  def pention_params
    params.require(:pention).permit(:year, :contribution)
  end
end
