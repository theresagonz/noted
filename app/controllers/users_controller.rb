class UsersController < ApplicationController

  get '/signup' do
    erb :'users/signup'
  end

  post '/login' do
  end

end
