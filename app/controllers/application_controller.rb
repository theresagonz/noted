require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
    register Sinatra::Flash
  end

  get "/" do
    redirect_to_new_note_or_index_if_logged_in(session)
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
        redirect to '/'
      end
    end

    def redirect_to_new_note_or_index_if_logged_in(session)
      if logged_in?(session)
      # if a user's last note was created today, skip to index
      # otherwise route to create note
        if !current_user(session).notes.empty? && current_user(session).notes.last.created_at.to_date == Time.now.to_date
          redirect to '/index'
        else
          redirect to '/notes/new'
        end
      end
    end

    def redirect_to_index_if_unauthorized(session)
      # if the note is private and the user is not the note's creator, redirect to /index
      if @note.public == 0 && @note.user != current_user(session)
        flash[:error] = "Hey, that's not your note"
        redirect to '/index'
      end
    end
  end
  
end
