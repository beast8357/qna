require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:question_2) { create(:question, author: user_2) }

  describe '#author_of?' do
    context 'current user is the author of the subject' do
      it 'returns true' do
        expect(user.author_of?(question)).to be_truthy
      end
    end

    context 'current user is not the author of the subject' do
      it 'returns false' do
        expect(user.author_of?(question_2)).to be_falsey
      end
    end
  end
end
