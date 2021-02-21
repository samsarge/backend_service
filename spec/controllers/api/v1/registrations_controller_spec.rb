require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :request do
  let!(:developer) { create :user }
  let!(:api) { create :backend, user_id: developer.id }

  before do
    Apartment::Tenant.switch(api.subdomain) do
      Multitenanted::User.create(email: 'normal_user@test.com', password: 'Test123!')
    end

    host!("#{api.subdomain}.lvh.me")
  end

  let(:params) do
    {
      api_v1_user: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  context 'creating a new user account' do
    before do
      post api_v1_user_registration_path, params: params
      Apartment::Tenant.switch!(api.subdomain)
    end

    context 'when user is unauthenticated' do
      it 'returns 200' do
        expect(response.status).to eq 200
      end

      it 'returns a new user' do
        expect(response.body).to eq(Multitenanted::User.last.to_json)
      end
    end

    context 'when user already exists' do
      let(:params) do
        {
          api_v1_user: {
            email: 'normal_user@test.com',
            password: 'Test123!'
          }
        }
      end

      it 'returns bad request status' do
        expect(response.status).to eq 422
      end

      it 'returns validation errors' do
        errors = JSON.parse(response.body)['errors']

        expect(errors.first['title']).to eq 'Unprocessable Entity'
        expect(errors.first['detail']).to eq('email' => ['has already been taken'])
      end
    end
  end
end