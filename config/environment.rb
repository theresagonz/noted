require 'sinatra/base'
require 'sinatra/flash'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "postgresql",
  :database => "noted"
)

require_all 'app'
