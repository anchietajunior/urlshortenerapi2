require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'mongoid'

Mongoid.load! 'mongoid.config'

class Url
  include Mongoid::Document
  include Mongoid::Timestamps

  field :original_url, type: String
  field :shortened_url, type: String
end

get '/' do
  erb :index
end

post '/urls' do
  headers('Content-Type' => :json)
  url = Url.new(JSON.parse(request.body.read)).save
  url.to_json
end

get ('/version') { "1.0" }
