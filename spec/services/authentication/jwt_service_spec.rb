require './app.rb'
require './spec/spec_helper'

set :environment, :test

RSpec.describe Authentication::JwtService do

  let(:email) do
    "user@testing.com"
  end

  before(:each) do
    @user = User.new
    @user.email = email
    @user.name = "Anchieta"
    @user.password = BCrypt::Password.create("12345678")
    @user.save!
  end

  after(:each) do
    User.where(email: email).delete_all
  end

  let(:token) do
    described_class.encode(user_id: @user.id)
  end

  let(:decoded_token) do
    described_class.decode(token)
  end

  describe '#encoding' do
    it 'has a user' do
      expect(@user.is_a?(User)).to be_truthy
    end

    it 'encode a user token' do
      expect(token).to_not be_nil
    end
  end

  describe '#decoding' do
    it 'has the correct user' do
      searched_user = User.find(BSON::ObjectId.from_string(decoded_token)) 
      expect(searched_user).to eq(@user)
    end
  end
end