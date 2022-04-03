# frozen_string_literal: true

class API::Admin::BaseController < ApplicationController
  before_action :admin?

  private

  def admin?
    return if user_signed_in?

    render json: { type: '/problems/authentication_required', title: 'ログインしてください' }, status: :unauthorized, content_type: 'application/problem+json'
  end
end
