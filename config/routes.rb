require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'

get '/' do
  erb :index
end

namespace '/api/v1' do

  error Mongoid::Errors::DocumentNotFound do
    halt(404, { message: "Url not found" }.to_json)
  end

  post '/users' do
    headers('Content-Type' => :json)
    user = User.new(JSON.parse(request.body.read))
    if user.save
      user.to_json
    else
      user.errors.to_json
    end
  end

  get '/urls' do
    Url.all.to_json
  end

  get '/urls/:shortened_url' do |shortened_url|
    Url.find_by(shortened_url: shortened_url).to_json
  end

  post '/urls' do
    headers('Content-Type' => :json)
    url = Url.new(JSON.parse(request.body.read)).save
    url.to_json
  end

  get('/version') { "1.0" }

  not_found do
    { message: "Not found" }.to_json
  end
end
