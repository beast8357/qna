require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }

  subject { described_class }

  permissions :index?, :show? do
    it 'grants access to all users' do
      expect(subject).to permit(nil, create(:question))
    end
  end

  permissions :new?, :create? do
    it 'grants access if the user is signed in' do
      expect(subject).to permit(user, create(:question))
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if the user is admin' do
      expect(subject).to permit(admin, create(:question))
    end

    it 'grants access if the user is the author of the question' do
      expect(subject).to permit(user, create(:question, author_id: user.id))
    end

    it 'denies access if the user is not the author of the question' do
      expect(subject).to_not permit(User.new, create(:question))
    end
  end
end
