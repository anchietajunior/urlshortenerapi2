require './app/services/app_service'

module Authentication
  class AuthenticationService < AppService
    def initialize(authorization)
      @authorization = authorization
    end

    def call
      authenticate!
    rescue StandardError => e
      Result.new(false, e.message, nil)
    end

    private

    attr_accessor :authorization, :token

    def token
      @token ||= authorization.present? ? authorization.split(' ').last : nil 
    end

    def user
      @user ||= User.find(decode_jwt_token)
    end

    def decode_jwt_token
      Authentication::JwtService.decode(token)
    end

    def authenticate!
      raise "Invalid Token!" if user.blank?
      Result.new(true, nil, user)
    end
  end
end
