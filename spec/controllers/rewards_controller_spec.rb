require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:reward) { create(:reward, question: question, answer: answer, user_id: user.id) }

  describe 'GET #index' do
    context 'Authenticated user' do
      before do
        login(user)
        get :index
      end

      it "populates an array of all user's rewards" do
        expect(assigns(:rewards)).to match_array(user.rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end
end
