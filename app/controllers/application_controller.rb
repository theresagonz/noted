require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
    register Sinatra::Flash
    # config.active_record.default_timezone = :local
  end

  get "/" do
    redirect_if_logged_in(session)
    erb :welcome
  end

  helpers do
    def current_user(session)
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?(session)
      !!session[:user_id]
    end

    def redirect_if_not_logged_in(session)
      if !logged_in?(session)
        redirect to '/'
      end
    end

    def redirect_if_logged_in(session)
      if logged_in?(session)
        redirect to '/index'
      end
    end
  end
  
end
