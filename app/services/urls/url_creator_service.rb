require './app/services/app_service'

module Urls
  class UrlCreatorService < AppService
    def initialize(params)
      @params = params
    end

    def call
      create_url!
      Result.new(true, nil, url)
    rescue StandardError => e
      Result.new(false, { error: e.summary }, nil)
    end

    private

    attr_accessor :params, :url

    def create_url!
      loop do
        @url = Url.new url_params
        break if @url.save!
      end
    end

    def shortened_url
      chars = ['0'..'9', 'A'..'Z', 'a'..'z'].map(&:to_a).flatten
      return 6.times.map { chars.sample }.join
    end

    def expires_at
      return params["expires_at"].to_i.hours.from_now if params["expires_at"].present?
      3.hours.from_now
    end

    def url_params
      {}.tap do |hash|
        hash[:original_url] = params["original_url"]
        hash[:shortened_url] = shortened_url
        hash[:expires_at] = expires_at
        hash[:user] = User.last
      end
    end
  end
end
