require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:voteable) }
  it { should validate_presence_of(:user) }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'author_cant_vote validation' do
    it 'prevents the author of the subject from voting' do
      vote = build(:vote, voteable: question, user: user)

      expect(vote).to_not be_valid
      expect(vote.errors[:vote]).to include("Author can't vote")
    end
  end
end
