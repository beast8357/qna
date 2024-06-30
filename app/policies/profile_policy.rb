class ProfilePolicy < ApplicationPolicy
  def me?
    user.present?
  end

  def others?
    user&.admin?
  end
end
