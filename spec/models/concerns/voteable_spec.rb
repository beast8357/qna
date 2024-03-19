require 'rails_helper'

shared_examples_for 'voteable' do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:voteable) { described_class.to_s.underscore.to_sym }

  describe '#votes_sum' do
    it 'checks for votes: 1, -1, 1' do
      create(:vote, voteable: voteable, value: 1)
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: 1)

      expect(voteable.votes_sum).to eq 1
    end

    it 'checks for votes: 1, -1, 1' do
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: 1)

      expect(voteable.votes_sum).to eq(-1)
    end
  end

  describe '#voted_by?' do
    let(:user) { create(:user) }

    context 'user has already voted' do
      it 'returns true' do
        create(:vote, voteable: voteable, user: user)
        expect(voteable.voted_by?(user)).to be_truthy
      end
    end

    context 'user has not voted yet' do
      it 'returns false' do
        expect(voteable.voted_by?(user)).to be_falsey
      end
    end
  end
end
