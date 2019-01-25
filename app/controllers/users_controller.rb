class UsersController < ApplicationController
  get '/signup' do
    redirect_to_new_note_if_logged_in(session)
    erb :'users/new'
  end

  # get '/index' do
  #   redirect_to_login_if_not_logged_in(session)
  #   @my_notes = Note.where(user_id: current_user(session).id)
  #   @public_notes = Note.where("user_id != ? AND public = ?", current_user(session).id, '1')
  #   @tags = current_user(session).tags.uniq
    
  #   @popular_public_tags = Note.where(public: '1').collect{|note| note.tags}.flatten.group_by{|tag| tag.word}.sort_by{|k,v| v.size}.reverse.collect{|k,v| v[0]}
  #   erb :'users/index'
  # end

  get "/edit-profile" do
    redirect_to_login_if_not_logged_in(session)
    @user = current_user(session)
    erb :'users/edit'
  end

  patch '/users/:id' do
    redirect_to_index_if_unauthorized_to_edit_user(session)
    @user = current_user(session)
    @user.name = params[:name]
    @user.username = params[:username]
    if user.save
      flash[:message] = "Profile changes saved"
      redirect to '/notes/my-notes'
    else
      flash[:error] = user.errors.full_messages.uniq
      redirect to 'edit-profile'
    end
  end

  post '/users' do
    @user = User.new(params)
    if @user.save
      flash[:message] = "Welcome to your shiny new account! Make your first note below"
      session[:user_id] = @user.id
      redirect to '/notes/new'
    else
      flash[:error] = @user.errors.full_messages.uniq
      redirect to '/signup'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # if a user's last note was created today, skip to index
      # otherwise route to create note
      redirect_to_new_note_if_logged_in(session)
    else
      flash[:error] = "Username and/or password is incorrect"
      redirect to '/'
    end
  end

  delete '/users/:id' do
    @user = User.find(params[:id])
    redirect_to_index_if_unauthorized_to_edit_user(session)
    User.destroy(params[:id])
    session.clear
    flash[:message] = "Account deleted successfully"
    redirect to '/'
  end

  get '/logout' do
    session.clear
    redirect to '/'
  end
end
