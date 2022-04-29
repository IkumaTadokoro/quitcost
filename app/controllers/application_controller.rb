# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :staging?

  def basic_auth
    authenticate_or_request_with_http_basic do |user, password|
      user == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  protected

  def staging?
    ENV['DB_NAME'] == 'quitcost_staging'
  end
end
