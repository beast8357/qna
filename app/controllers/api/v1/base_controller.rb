# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  include ActiveStorage::SetCurrent

  protect_from_forgery with: :null_session

  before_action :doorkeeper_authorize!

  private

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
