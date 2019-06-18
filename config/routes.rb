require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'

get '/' do
  erb :index
end

before '/api/v1/urls' do
  headers('Content-Type' => :json)
  result = Authentication::AuthenticationService.call(request.env['HTTP_AUTHORIZATION'])
  halt 401, {error: 'Unauthorized'}.to_json unless result.success?
end

namespace '/api/v1' do

  error Mongoid::Errors::DocumentNotFound do
    halt(404, { message: "Url not found" }.to_json)
  end

  post '/login' do
    result = Authentication::TokenGeneratorService.call(JSON.parse(request.body.read))
    if result.success?
      { jwt: result.value }.to_json
    else
      { errors: result.error }.to_json
    end
  end

  post '/subscribe' do
    headers('Content-Type' => :json)
    result = Users::UserCreatorService.call(JSON.parse(request.body.read))
    if result.success? 
      { created: result.value }.to_json
    else
      { errors: result.error }.to_json
    end
  end

  get '/urls' do
    p "HEADERS: #{headers}"
    Url.all.to_json
  end

  get '/urls/:shortened_url' do |shortened_url|
    Url.find_by(shortened_url: shortened_url).to_json
  end

  post '/urls' do
    headers('Content-Type' => :json)
    result = Urls::UrlCreatorService.call(JSON.parse(request.body.read))
    if result.success?
      result.value.to_json
    else
      result.error.to_json
    end
  end

  get('/version') { "1.0" }

  not_found do
    { message: "Not found" }.to_json
  end
end
