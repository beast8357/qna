require 'rails_helper'

describe 'Answers API', type: :request do
  let(:access_token) { create(:access_token).token }
  let(:method) { :get }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answer) { answers.first }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answer_json) { json['answers'].first }

      before { get api_path, params: { access_token: access_token} , headers: headers }

      it 'returns the list of all question answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        expect(answer_json).to include('id' => answer.id,
                                       'body' => answer.body,
                                       'created_at' => answer.created_at.as_json,
                                       'updated_at' => answer.updated_at.as_json)
      end

      it 'contains user object' do
        expect(answer_json['author']['id']).to eq answer.author_id
      end
    end
  end

  describe 'GET /api/v1/question/:question_id/answers/:id' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_files, question: question) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let(:api_path) { api_v1_question_answer_path(question, answer) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answer_json) { json['answer'] }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it 'returns all public fields' do
        expect(answer_json).to include('id' => answer.id,
                                       'body' => answer.body,
                                       'created_at' => answer.created_at.as_json,
                                       'updated_at' => answer.updated_at.as_json)
      end

      describe 'comments' do
        let(:comments_json) { answer_json['comments'] }
        let(:comment_json) { answer_json['comments'].first }
        let(:answer_comment) { answer.comments.first }

        it 'returns the list of all answer comments' do
          expect(comments_json.size).to eq 2
        end

        it 'returns all public fields' do
          expect(comment_json).to include('id' => answer_comment.id,
                                          'body' => answer_comment.body,
                                          'created_at' => answer_comment.created_at.as_json,
                                          'updated_at' => answer_comment.updated_at.as_json)
        end

        it 'returns the author of the comment' do
          expect(comment_json['author']['id']).to eq answer_comment.author_id
        end
      end

      describe 'links' do
        let(:links_json) { answer_json['links_list'] }
        let(:answer_link) { answer.links.first }

        it 'returns the list of all answer links' do
          expect(links_json.size).to eq 2
        end

        it 'returns all public fields' do
          expect(links_json).to include('name' => answer_link.name,
                                        'url' => answer_link.url)
        end
      end

      describe 'files' do
        let(:files_json) { answer_json['files_list'].first }

        it 'returns the list of all answer files' do
          expect(files_json.size).to eq 2
        end

        it 'returns all public fields' do
          %w(name url).each do |attr|
            expect(files_json).to have_key(attr)
          end
        end
      end
    end
  end
end
