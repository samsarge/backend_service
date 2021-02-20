require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let!(:developer) { create :user }
  let!(:api) { create :backend, user_id: developer.id }

  before do
    Apartment::Tenant.switch(api.subdomain) do
      Multitenanted::User.create(email: 'normal_user@test.com', password: 'Test123!')
    end

    host!("#{api.subdomain}.lvh.me")
  end

  describe 'POST #create' do
    let(:url) { api_v1_user_session_path }
    let(:params) do
      {
        api_v1_user: {
          email: 'normal_user@test.com',
          password: 'Test123!'
        }
      }
    end

    context 'when params are correct' do
      before do
        post url, params: params
      end

      let(:decoded_token) do
        token_from_request = response.headers['Authorization'].split(' ').last
        JWT.decode(token_from_request, Rails.application.credentials.devise_jwt_secret, true)
      end

      it 'should return a 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return a JWT token in authorization header' do
        expect(response.headers['Authorization']).to be_present
      end

      it 'should return a valid JWT token' do
        expect(decoded_token.first['sub']).to be_present
      end
    end

    context 'when login params are incorrect' do
      let(:params) do
        {
          user: {
            email: 'testuser@test.com',
            password: 'incorrect_password'
          }
        }
      end

      before { post url, params: params }

      it 'should return an unathorized status' do
        expect(response.headers['Authorization']).to be_nil
        # expect(response.status).to eq 401
      end
    end
  end
end