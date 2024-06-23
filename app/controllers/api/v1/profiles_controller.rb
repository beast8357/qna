# frozen_string_literal: true

class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  def me
    render json: current_user
  end

  private

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
