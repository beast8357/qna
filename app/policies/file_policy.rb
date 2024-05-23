class FilePolicy < ApplicationPolicy
  def destroy?
    user&.author_of?(record) || user&.admin?
  end
end
