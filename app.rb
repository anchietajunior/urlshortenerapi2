require 'sinatra'
require 'require_all'

require_all 'config'
require_all 'app/models'

require_all 'app/services/users'
require_all 'app/services/authentication'
require_all 'app/services/urls'


