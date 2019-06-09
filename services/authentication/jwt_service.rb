require 'jwt'

module Authentication
  class JwtService

    def self.encode(payload, expiration = 2.hours.from_now)
      payload[:exp] = expiration.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
      body = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature
      nil
    rescue
      nil
    end

  end
end
