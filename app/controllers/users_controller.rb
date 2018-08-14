class UsersController < ApplicationController

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    new_user = User.new(params)
    if new_user.save
      new_user.save
      session[id: new_user.id]
      redirect to '/nuggets'
    else
      flash[:error] = new_user.errors.full_messages.uniq
      redirect to '/signup'
    end

  end

  post '/login' do

  end

end
