require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:access_token) { create(:access_token).token }
    let(:api_path) { '/api/v1/questions' }
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.first }
    let(:question_json) { json['questions'].first }
    let!(:answers) { create_list(:answer, 3, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token }, headers: headers }

      it 'returns the list of all questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w(id title body created_at updated_at).each do |attr|
          expect(question_json[attr]).to eq question.public_send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_json['author']['id']).to eq question.author_id
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_files) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:access_token) { create(:access_token).token }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_json) { json['question'] }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it 'returns all public fields' do
        %w(id title body created_at updated_at).each do |attr|
          expect(question_json[attr]).to eq question.public_send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_json) { question_json['comments'] }
        let(:comment_json) { question_json['comments'].first }

        it 'contains a list of comments' do
          expect(comments_json.count).to eq 2
        end

        it 'returns all public fields' do
          %w(id body created_at updated_at).each do |attr|
            expect(comment_json[attr]).to eq question.comments.first.public_send(attr).as_json
          end
        end

        it 'return the author of the comment' do
          expect(comment_json['author']['id']).to eq question.comments.first.author_id
        end
      end

      describe 'links' do
        let(:links_json) { question_json['links_list'].first }

        it 'contains a list of links' do
          expect(links_json.count).to eq 2
        end

        it 'returns all public fields' do
          %w(name url).each do |attr|
            expect(links_json[attr]).to eq question.links.first.public_send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:files_json) { question_json['files_list'].first }

        it 'contains a list of files' do
          expect(files_json.count).to eq 2
        end

        it 'returns all fields' do
          %w(name url).each do |attr|
            expect(files_json).to have_key(attr)
          end
        end
      end
    end
  end
end
