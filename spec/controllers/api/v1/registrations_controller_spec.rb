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
    let(:request) { post api_v1_user_registration_path, params: params }

    before do
      Apartment::Tenant.switch!(api.subdomain)
    end

    context 'when user is unauthenticated' do
      before { request }

      it 'returns 200' do
        expect(response.status).to eq 200
      end

      it 'returns a new user' do
        expect(response.body).to eq(Multitenanted::User.last.to_json)
      end
    end

    context 'with the feature turned off' do
      before do
        api.configuration.update(user_registrations_enabled: false)
      end

      it 'should forbid' do
        request
        expect(response.status).to eq 403
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

      before { request }

      it 'returns bad request status' do
        expect(response.status).to eq 422
      end

      it 'returns validation errors' do
        errors = JSON.parse(response.body)
        expect(response.status).to eq 422
        expect(errors['email']).to eq(['has already been taken'])
      end
    end
  end
end