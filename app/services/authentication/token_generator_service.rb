require 'bcrypt'
require './app/services/app_service'

module Authentication
  class TokenGeneratorService < AppService
    def initialize(params)
      @params = params
    end

    def call
      Result.new(true, nil, authenticate!)
    rescue StandardError => e
      Result.new(false, e.message, nil)
    end

    private

    attr_accessor :params

    def user
      User.find_by(email: params['email'])
    end

    def valid_password?
      encrypted_password = BCrypt::Password.new(user.password)
      encrypted_password == params['password']
    end

    def authenticate!
      return Authentication::JwtService.encode(user_id: user.id) if valid_password?
      raise "Invalid Credentials"
    end
  end
end
