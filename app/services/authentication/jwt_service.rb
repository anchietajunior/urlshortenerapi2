require 'jwt'
SECRET_KEY = "d5d6d785c545bcc1e16e960497fb40328952f3754b925fb8edff9a0b437da4d08f315462b3f6b53ba6c9adc050a94922a72304a13e8aa26cb4d5fb2d99471f33"

module Authentication
  class JwtService

    def self.encode(payload, expiration = 2.hours.from_now)
      payload[:exp] = expiration.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
      body = JWT.decode(token, SECRET_KEY)
      body.first['user_id']['$oid']
    rescue JWT::ExpiredSignature
      nil
    rescue
      nil
    end

  end
end
