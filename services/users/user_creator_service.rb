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
      p "ERROR =============>>>>"
      p e
      Result.new(false, { message: e.summary }, nil)
    end

    private

    attr_accessor :params

    def encrypted_password
      @password ||= params["password"].present? ? BCrypt::Password.create(params["password"]) : nil
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
