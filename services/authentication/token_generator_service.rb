require './services/app_service'

module Authentication
  class TokenGeneratorService < AppService
    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      Result.new(true, nil, authenticate!)
    rescue StandardError => e
      Result.new(false, e.message, nil)
    end

    private

    attr_accessor :email, :password

    def user
      @user ||= User.find_for_authentication(email: email)
    end

    def authenticate!
      return Jwt::TokenService.encode(user_id: user.id) if user && user.valid_password?(password)
      raise "Invalid Credentials"
    end
  end
end
