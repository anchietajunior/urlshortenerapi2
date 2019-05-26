class Url
  include Mongoid::Document
  include Mongoid::Timestamps

  field :original_url, type: String
  field :shortened_url, type: String
end
