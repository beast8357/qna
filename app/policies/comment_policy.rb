class CommentPolicy < ApplicationPolicy
  def add_comment?
    user.present?
  end
end
