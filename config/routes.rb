require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require './services/users/user_creator_service'
require './services/urls/url_creator_service'

get '/' do
  erb :index
end

before '/api/v1/*' do
  p "HEADERS =================>>>> #{headers}"
  p "REQUEST =================>>>> #{request}"
  @result = Authentication::AuthenticationService.call(headers)
  halt 401, {error: 'Unauthorized'}.to_json unless @result.success?
end

post '/api/login' do

end

namespace '/api/v1' do

  error Mongoid::Errors::DocumentNotFound do
    halt(404, { message: "Url not found" }.to_json)
  end

  post '/login' do
    result = Authentication::TokenGeneratorService.call(session_params[:email], session_params[:password])
    if result.success?
      render json: { jwt: result.value }, status: :ok
    else
      render json: { errors: result.error }, status: :bad
    end
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
