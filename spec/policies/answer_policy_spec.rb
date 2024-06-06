require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user)}
  let(:admin) { create(:user, admin: true) }

  subject { described_class }

  permissions :index?, :show? do
    it 'grants access to all users' do
      expect(subject).to permit(nil, build(:answer))
    end
  end

  permissions :new?, :create? do
    it 'grants access if the user is signed in' do
      expect(subject).to permit(user, build(:answer))
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if the user is admin' do
      expect(subject).to permit(admin, build(:answer))
    end

    it 'grants access if the user is the author of the answer' do
      expect(subject).to permit(user, build(:answer, author_id: user.id))
    end

    it 'denies access if the user is not the author of the answer' do
      expect(subject).to_not permit(user, build(:answer))
    end
  end

  permissions :best? do
    it 'grants access if the user is admin' do
      expect(subject).to permit(admin, build(:answer))
    end

    it 'grants access if the user is the author of the question' do
      question = create(:question, author_id: user.id)
      expect(subject).to permit(user, build(:answer, question_id: question.id))
    end

    it 'denies access if the user is not the author of the question' do
      expect(subject).to_not permit(user, build(:answer))
    end
  end
end
