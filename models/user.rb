class User
 include Mongoid::Document
 include Mongoid::Timestamps

 field :name, type: String
 field :email, type: String
 field :password, type: String

 validates_presence_of :name
 validates_presence_of :email
 validates_presence_of :password

 validates_uniqueness_of :email
end
