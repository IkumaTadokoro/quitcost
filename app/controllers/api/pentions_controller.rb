# frozen_string_literal: true

class Api::PentionsController < ApplicationController
  def index
    @pentions = Pention.order(:year).all.page(params[:page])
  end
end
