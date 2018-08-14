class UsersController < ApplicationController

  get '/signup' do
    redirect_if_logged_in(session)
    erb :'users/signup'
  end

  get '/index' do
    redirect_if_not_logged_in(session)
    erb :'nuggets/index'
  end

  post '/signup' do
    new_user = User.new(params)
    # if signup info is valid
    if new_user.save
      # save new user to db
      new_user.save
      # save user's info in session
      session[id: new_user.id]
      # redirect to
      redirect to '/index'
    else
      flash[:error] = new_user.errors.full_messages.uniq
      redirect to '/signup'
    end

  end

  post '/login' do

  end

end
