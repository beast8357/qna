require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:voteable) }
  it { should validate_presence_of(:user) }

  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'author_cant_vote validation' do
    it 'prevents the author of the subject from voting' do
      vote = build(:vote, voteable: question, user: user)

      expect(vote).to_not be_valid
      expect(vote.errors[:vote]).to include("Author can't vote")
    end
  end

  describe 'user_cant_vote_twice validation' do
    it 'prevents the user from voting twice' do
      create(:vote, voteable: question, user: user_2)
      vote_2 = build(:vote, voteable: question, user: user_2)

      expect(vote_2).to_not be_valid
      expect(vote_2.errors[:vote]).to include("User can't vote twice")
    end
  end
end
