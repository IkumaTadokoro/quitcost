# frozen_string_literal: true

class Api::PentionsController < ApplicationController
  def index
    @pentions = Pention.order(:year).all.page(params[:page])
  end

  def destroy
    pention = Pention.find(params[:id])
    pention.destroy
    render status: :ok, json: { id: pention.id }
  end
end
