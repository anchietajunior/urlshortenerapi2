require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'

get '/' do
  erb :index
end

namespace '/api/v1' do

  get '/urls' do
    Url.all.to_json
  end

  get '/urls/:shortened_url' do |shortened_url|
    Url.where(shortened_url: shortened_url).last.to_json
  end

  post '/urls' do
    headers('Content-Type' => :json)
    url = Url.new(JSON.parse(request.body.read)).save
    url.to_json
  end

  get('/version') { "1.0" }
end
