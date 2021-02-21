
require 'rails_helper'

RSpec.describe Api::V1::RecordsController, type: :request do
  let!(:developer) { create :user }
  let!(:api) { create :backend, user_id: developer.id }

  before do
    Apartment::Tenant.switch(api.subdomain) do
      Multitenanted::User.create(email: 'normal_user@test.com', password: 'Test123!')
      table = create :multitenanted_table,
                     name: 'contacts',
                     structure: { columns: %w[name email phone] }

       create :multitenanted_record,
              multitenanted_table_id: table.id,
              values: { name: 'Tester', email: 'existing@record.com', phone: '077777777777' }
    end

    host!("#{api.subdomain}.lvh.me")
  end

  # The url is created and resolved dynamically based on table names
  # so if you have a table called conctacts then the routes for /api/v1/contacts will work
  context 'not logged in as a tenant user, just calling the api' do
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

      it 'should render the correct results back' do
        request
        expect(response.status).to eq 201
        expect(response.body).to include('bestrubydev@test.com')
      end
    end

    describe 'GET #show' do
      let(:id) { Multitenanted::Record.last.id }
      let(:url) { "/api/v1/contacts/#{id}" }
      let(:request) { get url }

      before { request }

      context 'with a records id' do
        it 'should return the specific record' do
          expect(response.status).to eq 200
          expect(response.body).to include('Tester', 'existing@record.com', '077777777777')
        end
      end

      context 'a non existant ID' do
        let(:id) { 9999999 }
        it 'should return a not found error' do
          expect(response.status).to eq 404
        end
      end
    end

    describe 'PUT #update' do
      let(:record) { Multitenanted::Record.last }
      let(:url) { "/api/v1/contacts/#{record.id}" }
      let(:request) { patch url, params: params }

      context 'valid params' do
        let(:params) { { contact: { name: 'updated name' } } }
        it 'should update the record with new values' do
          expect { request }.to change { record.reload.values['name'] }.from('Tester').to('updated name')
          expect(response.body).to include('updated name')
          expect(response.status).to eq 200
        end
      end

      context 'invalid params' do
        let(:params) { { contact: { invalid_column: 'updated name' } } }
        it 'should return bad request' do
          request
          expect(response.status).to eq 400 # bad request, you sent the wrong shit
        end
      end
    end
  end
end
