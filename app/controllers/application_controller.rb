class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
    register Sinatra::Flash
  end

  get "/" do
    redirect_to_new_note_if_logged_in(session)
    erb :welcome
  end

  helpers do
    def current_user(session)
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?(session)
      !!session[:user_id]
    end

    def redirect_to_login_if_not_logged_in(session)
      if !logged_in?(session)
        flash[:error] = "Please log in or sign up"
        redirect to '/'
      end
    end

    def redirect_to_new_note_if_logged_in(session)
      if logged_in?(session)
      # if a user's last note was created today, skip to index
      # otherwise route to create note
        redirect to '/notes/new'
      end
    end

    def redirect_to_index_if_unauthorized_to_view(session)
      # if the note is private and the user is not the note's creator, redirect to /index
      if @note.public == 0 && @note.user != current_user(session)
        flash[:error] = "Hey, that's not your note"
        redirect to '/notes/my-notes'
      end
    end

    def redirect_to_index_if_unauthorized_to_edit_note(session)
      # if the current user is not the note's the note's creator, redirect to /index
      if @note.user != current_user(session)
        flash[:error] = "Hey, that's not your note"
        redirect to '/notes/my-notes'
      end
    end

    def redirect_to_index_if_unauthorized_to_edit_user(session)
      # if current user is not the profile owner, redirect to /index
      if @user != current_user(session)
        flash[:error] = "Hey, that's not your profile"
        redirect to '/notes/my-notes'
      end
    end
  end
  
end
