class QuestionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user.present?
  end

  def create?
    new?
  end

  def edit?
    user&.author_of?(record) || user&.admin?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
