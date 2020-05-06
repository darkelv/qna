require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['user'] }

      before do
        do_request(
          method, api_path,
          params: { access_token: access_token.token },
          headers: headers
        )
      end

      it 'return  200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method) { :get }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable'
    end

    context 'authorized' do
      let(:admin) { create(:user, admin: true) }
      let!(:users) { create_list(:user, 2) }
      let(:users_response) { json['users'] }
      let(:last_response) { json['users'].last }
      let(:access_token) { create(:access_token, resource_owner_id: admin.id) }

      before do
        do_request(
          method, api_path,
          params: { access_token: access_token.token },
          headers: headers
        )
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users without me' do
        expect(users_response.size).to eq 2
        expect(users_response.any? { |user| user['id'] == admin.id }).to be_falsey
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(last_response[attr]).to eq users.last.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(last_response).to_not have_key(attr)
        end
      end
    end
  end
end
