# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_user, serializer: UserSerializer
  end

  def others
    @users = User.where.not(id: current_user.id)
    render json: @users, each_serializer: UserSerializer
  end
end
