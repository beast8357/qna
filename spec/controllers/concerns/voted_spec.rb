require 'rails_helper'

shared_examples_for 'voted' do
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:voteable) { create(described_class.to_s.sub!("Controller", "").underscore.singularize.to_sym) }

  describe 'PATCH #like' do
    let!(:vote) { create(:vote, user: user_2, voteable: voteable, value: 1) }

    subject(:like) do
      patch :like, params: { id: voteable.id, format: :json }
    end

    context 'Authenticated user' do
      before { login(user) }

      it 'gets response status OK' do
        like
        expect(response.status).to eq 200
      end

      it 'increments votes sum by 1' do
        expect { like }.to change { voteable.reload.votes_sum }.from(1).to(2)
      end
    end

    context 'Unauthenticated user' do
      it 'gets response status Unauthorized' do
        like
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #dislike' do
    let!(:vote) { create(:vote, user: user_2, voteable: voteable, value: -1) }

    subject(:dislike) do
      patch :dislike, params: { id: voteable.id, format: :json }
    end

    context 'Authenticated user' do
      before { login(user) }

      it 'has response status OK' do
        dislike
        expect(response.status).to eq 200
      end

      it 'decrements votes sum by 1' do
        expect { dislike }.to change { voteable.reload.votes_sum }.from(-1).to(-2)
      end
    end

    context 'Unauthenticated user' do
      it 'gets response status Unauthorized' do
        dislike
        expect(response.status).to eq 401
      end
    end
  end
end
