require './app.rb'
require './spec/spec_helper'

set :environment, :test

RSpec.describe Authentication::TokenGeneratorService do

  let(:password) do
    BCrypt::Password.create("12345678")
  end

  let!(:user) { User.create!(name: "Anchieta", email: "user@testing.com", password: password) }

  let(:params) do
    '{
      "email": "user@testing.com",
      "password": "12345678"
    }'
  end

  after(:each) do
    User.where(email: "user@testing.com").delete_all
  end

  let(:service) do
    described_class.call(JSON.parse(params))
  end

  describe '#call' do
    it 'has a success? true value' do
      expect(service.success?).to be_truthy
    end
  end

end