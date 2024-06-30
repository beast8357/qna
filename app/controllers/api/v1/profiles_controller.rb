# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize User, policy_class: ProfilePolicy

    render json: current_user, serializer: UserSerializer
  end

  def others
    authorize User, policy_class: ProfilePolicy

    @users = User.where.not(id: current_user.id)
    render json: @users, each_serializer: UserSerializer
  end
end
