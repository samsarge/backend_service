
require 'rails_helper'

RSpec.describe Backend, type: :model do
  let!(:developer) { create :user }

  # The backend model is called backend instead of just API in case it wraps
  # more than just API functionality later, like file storage etc.
  describe 'Validations' do
    context 'creating with a reserved subdomain' do
      it 'should be invalid' do
        Backend::RESERVED_SUBDOMAINS.each do |sd|
          expect(
            build(:backend, user_id: developer.id, subdomain: 'www', name: 'valid_name')
          ).to be_invalid
        end
      end
    end

    context 'creating a backend with no name' do
      it 'should be invalid' do
        expect(
          build(:backend, user_id: developer.id, subdomain: 'validsubdomain', name: '')
        ).to be_invalid
      end
    end
  end

  describe 'Hooks' do
    it 'should create a configuration  when it is created' do
      expect {
        developer.backends.create(name: 'Config test', subdomain: 'configtest')
      }.to change {
        Configuration.count
      }.by(1)

      expect(Configuration.last.backend_id).to eq Backend.last.id
    end
  end
end
