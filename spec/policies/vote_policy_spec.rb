require 'rails_helper'

RSpec.describe VotePolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:file_parent) { create(:question, author: user) }
  let(:file_parent_voted) { create(:question) }
  let!(:vote) { create(:vote, user: user, voteable: file_parent_voted) }

  subject { described_class }

  permissions :like?, :dislike? do
    it 'grants access if the user exists' do
      expect(subject).to permit(User.new, file_parent)
    end

    it 'denies access if the user is the author of the record' do
      expect(subject).to_not permit(user, file_parent)
    end
  end

  permissions :revote? do
    it 'grants access if the user has already voted for the record' do
      expect(subject).to permit(user, file_parent_voted)
    end

    it 'denies access if the user has not voted for the record' do
      expect(subject).to_not permit(user, build(:question))
    end
  end
end
