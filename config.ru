require './config/environment'
require 'sinatra/base'
require 'sinatra/flash'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

Rack::MethodOverride
use UsersController
use NuggetsController
run ApplicationController
