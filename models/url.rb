class Url
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :original_url, type: String
  field :shortened_url, type: String
  field :expires_at, type: DateTime

  validates_presence_of :original_url
  validates_presence_of :shortened_url
  validates_presence_of :user
  
  validates_uniqueness_of :shortened_url
end
