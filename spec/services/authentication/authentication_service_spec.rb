require './app.rb'
require './spec/spec_helper'

set :environment, :test

RSpec.describe Authentication::AuthenticationService do
  let!(:user) { User.create!(name: "Anchieta", email: "user@testing.com", password: password) }

  after(:each) do
    User.where(email: "user@testing.com").delete_all
  end

  let(:params) do
    {
      "email": "user@testing.com",
      "password": "12345678"
    }
  end

  let(:token) do

  end
end