class UsersController < ApplicationController

  get '/signup' do
    redirect_if_logged_in(session)
    erb :'users/signup'
  end

  get '/index' do
    redirect_if_not_logged_in(session)
    @my_notes = Note.where(user_id: current_user(session).id)
    @public_notes = Note.where("user_id != ? AND public = ?", current_user(session).id, '1')
    erb :'users/index'
  end

  # since I only want user to have access to own info, not using any /users routes
  get '/edit' do
    redirect_if_not_logged_in(session)
    @user = current_user(session)
    erb :'users/edit'
  end

  patch '/edit' do
    user = current_user(session)
    user.name = params[:name]
    user.username = params[:username]
    if user.save
      user.save
      flash[:message] = "Profile changes saved"
      redirect to '/index'
    else
      flash[:error] = user.errors.full_messages.uniq
      redirect to 'edit'
    end
  end

  post '/signup' do
    new_user = User.new(params)
    # if signup info is valid
    if new_user.save
      # save new user to db
      new_user.save
      # save user's info in session
      session[:user_id] = new_user.id
      # redirect to user's home page
      redirect to '/notes/new'
    else
      flash[:error] = new_user.errors.full_messages.uniq
      redirect to '/signup'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/notes/new'
    else
      flash[:error] = "Username and/or password is incorrect"
      redirect to '/'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/'
  end

end
