
require 'rails_helper'

RSpec.describe Api::V1::RecordsController, type: :request do
  let!(:developer) { create :user }
  let!(:api) { create :backend, user_id: developer.id }

  before do
    Apartment::Tenant.switch(api.subdomain) do
      Multitenanted::User.create(email: 'normal_user@test.com', password: 'Test123!')
      create :multitenanted_table,
             name: 'contacts',
             structure: { columns: %w[name email phone] }
    end

    host!("#{api.subdomain}.lvh.me")
  end

  # The url is created and resolved dynamically based on table names
  # so if you have a table called conctacts then the routes for /api/v1/contacts will work
  context 'not logged in' do
    describe 'POST #create' do
      let(:url) { '/api/v1/contacts' }
      let(:params) do
        {
          contact: {
            name: 'Sam',
            email: 'bestrubydev@test.com',
            phone: '077777777777'
          }
        }
      end

      let(:request) { post url, params: params }

      before { Apartment::Tenant.switch!(api.subdomain) }

      it 'should create the record' do
        expect { request }.to change { Multitenanted::Record.count }.by 1
        expect(Multitenanted::Record.last.values).to eq(
          'name' => 'Sam',
          'email' => 'bestrubydev@test.com',
          'phone' => '077777777777'
        )
      end
    end
  end
end
