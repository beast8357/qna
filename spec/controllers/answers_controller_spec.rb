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
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to the question path' do
      delete :destroy, params: { question_id: question, id: answer }

      expect(response).to redirect_to question_path(question)
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
end
