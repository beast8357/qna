require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:access_token) { create(:access_token).token }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

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
end
