require 'rails_helper'

shared_examples_for 'commented' do
  let!(:user) { create(:user) }
  let!(:commentable) { create(described_class.to_s.sub!('Controller', '').underscore.singularize.to_sym) }

  let!(:params) do
    if described_class.to_s == 'AnswersController'
      { id: commentable.id, question_id: commentable.question.id, body: 'comment text', format: :json }
    elsif described_class.to_s == 'QuestionsController'
      { id: commentable.id, body: 'comment text', format: :json }
    end
  end

  describe 'PATCH #add_comment' do
    let!(:comment) { create(:comment, commentable: commentable) }

    subject(:add_comment) do
      patch :add_comment, params: params
    end

    context 'Authenticated user' do
      before { login(user) }

      it 'has response status OK' do
        add_comment
        expect(response.status).to eq 200
      end

      it 'adds a comment to commentable' do
        add_comment
        last_comment = commentable.comments.last

        expect(last_comment.body).to eq 'comment text'
      end

      it "increments commentables's comments count by 1" do
        expect { add_comment }.to change { commentable.reload.comments.size }.by(1)
      end
    end

    context 'Unauthenticated user' do
      it 'has response status Unauthorized' do
        add_comment
        expect(response.status).to eq 401
      end
    end
  end
end
