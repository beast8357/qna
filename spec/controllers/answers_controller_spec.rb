require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question, author: user) }

    before { get :show, params: { id: answer, question_id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(Answer, :count).by(1)
      end

      it "renders the answer's create template" do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it "renders the answer's create template" do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, author: user) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it "renders destoy template" do
      delete :destroy, params: { question_id: question, id: answer }, format: :js

      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it "changes the answer's attributes" do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it "does not change the answer's attributes" do
          expect do
            patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

          expect(response).to render_template :update
        end
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Unauthenticated user' do
      it 'cannot mark the best answer' do
        patch :best, params: { id: answer, question_id: question }, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end

    context 'Authenticated user' do
      context "current user's question" do
        before { login(user) }

        it 'can mark the best answer' do
          patch :best, params: { id: answer, question_id: question }, format: :js
          answer.reload
          expect(answer.best).to eq true
        end

        it 'renders best template' do
          patch :best, params: { id: answer, question_id: question }, format: :js
          expect(response).to render_template :best
        end
      end

      context "other user's question" do
        before { login(create(:user)) }

        it 'cannot mark the best answer' do
          patch :best, params: { id: answer, question_id: question }, format: :js
          answer.reload
          expect(answer.best).to eq false
        end
      end

      context 'there is already the the best answer' do
        let!(:answer_2) { create(:answer, question: question, author: user, best: true) }

        before { login(user) }

        it 'can mark the other answer as the best' do
          patch :best, params: { id: answer, question_id: question }, format: :js
          answer.reload
          answer_2.reload
          expect(answer.best).to eq true
          expect(answer_2.best).to eq false
        end
      end
    end
  end
end
