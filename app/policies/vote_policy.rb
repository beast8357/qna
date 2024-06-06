class VotePolicy < ApplicationPolicy
  def like?
    user.present? && !user&.author_of?(record)
  end

  def dislike?
    like?
  end

  def revote?
    record.voted_by?(user)
  end
end
