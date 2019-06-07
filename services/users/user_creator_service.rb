require 'bcrypt'
require './services/app_service'

module Users
  class UserCreatorService < AppService
    def initialize(params)
      @params = params
    end

    def call
      Result.new(true, nil, create!)
    rescue StandardError => e
      Result.new(false, { error: e.summary }, nil)
    end

    private

    attr_accessor :params

    def encrypted_password
      return BCrypt::Password.create(params["password"]) if params["password"].present?
      nil
    end

    def create!
      user = User.new user_params
      user.save!
    end

    def user_params
      {}.tap do |hash|
        hash[:name] = params["name"]
        hash[:email] = params["email"]
        hash[:password] = encrypted_password
      end
    end
  end
end
