require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require './services/users/user_creator_service'

get '/' do
  erb :index
end

before '/api/*' do
  p "SECURED ROUTE ===================== >>>>>"
end

namespace '/api/v1' do

  error Mongoid::Errors::DocumentNotFound do
    halt(404, { message: "Url not found" }.to_json)
  end

  post '/users' do
    headers('Content-Type' => :json)
    result = Users::UserCreatorService.call(JSON.parse(request.body.read))
    if result.success? 
      result.value.to_json
    else
      result.error.to_json
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
