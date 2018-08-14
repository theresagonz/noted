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
      # redirect to user's home page
      redirect to '/index'
    else
      flash[:error] = new_user.errors.full_messages.uniq
      redirect to '/signup'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/index'
    else
      flash[:error] = "Username and/or password is incorrect"
      redirect to '/'
    end
  end

end
