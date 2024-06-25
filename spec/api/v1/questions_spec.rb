require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns status 401 if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns status 401 if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

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

      it 'contains short title' do
        expect(question_json['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_json) { question_json['answers'].first }

        it 'returns the list of all question answers' do
          expect(question_json['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w(id body author_id created_at updated_at).each do |attr|
            expect(answer_json[attr]).to eq answer.public_send(attr).as_json
          end
        end
      end
    end
  end
end
