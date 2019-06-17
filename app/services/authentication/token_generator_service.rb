require 'bcrypt'
require './app/services/app_service'

module Authentication
  class TokenGeneratorService < AppService
    def initialize(params)
      @params = params
    end

    def call
      p "USER =================>>>> #{user}"
      p "ENCRYPTED_PASSWORD =====>> #{encrypted_password}"
      Result.new(true, nil, authenticate!)
    rescue StandardError => e
      Result.new(false, e.message, nil)
    end

    private

    attr_accessor :params

    def user
      @user ||= User.find_by(email: params["email"])
    end

    def encrypted_password
      BCrypt::Password.new(params["password"])
    end

    def valid_password?
      encrypted_password == user.password
    end

    def authenticate!
      return Authentication::JwtService.encode(user_id: user.id) if user.present? && valid_password?
      raise "Invalid Credentials"
    end
  end
end
