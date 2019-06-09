SECRET_KEY = "d5d6d785c545bcc1e16e960497fb40328952f3754b925fb8edff9a0b437da4d08f315462b3f6b53ba6c9adc050a94922a72304a13e8aa26cb4d5fb2d99471f33"

require 'sinatra'
require 'require_all'

require_all 'config'
require_all 'models'

require_all 'services/users'
require_all 'services/authentication'
require_all 'services/urls'


