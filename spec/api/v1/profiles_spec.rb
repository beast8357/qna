require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/profiles' do
    let(:user) { create(:user, admin: true) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
    let(:method) { :get }

    context '/me' do
      let(:api_path) { '/api/v1/profiles/me' }

      it_behaves_like 'API Authorizable'

      context 'authorized' do
        before { get api_path, params: { access_token: access_token }, headers: headers }

        it_behaves_like 'fields returnable' do
          let(:user_item) { user }
          let(:json_item) { json['user'] }
        end
      end
    end

    context '/others' do
      let(:api_path) { '/api/v1/profiles/others' }

      it_behaves_like 'API Authorizable'

      context 'authorized' do
        let!(:users) { create_list(:user, 2) }

        before { get api_path, params: { access_token: access_token }, headers: headers }

        it_behaves_like 'fields returnable' do
          let(:user_item) { users.first }
          let(:json_item) { json['users'].first }
        end

        it 'does not have current user' do
          json['users'].each do |user_json|
            expect(user_json['id']).to_not eq user.id
          end
        end
      end

      context 'user is not the admin' do
        let(:user) { create(:user) }

        before { get api_path, params: { access_token: access_token }, headers: headers }

        it 'returns status 403' do
          expect(response.status).to eq 403
        end
      end
    end
  end
end
