class NotesController < ApplicationController
  get '/notes/new' do
    redirect_to_login_if_not_logged_in(session)
    @date = Time.now.strftime("%A, %B %d, %Y")
    erb :'notes/new'
  end
  
  get '/notes/:id' do
    redirect_to_login_if_not_logged_in(session)
    @note = Note.find_by(id: params[:id])
    redirect_to_index_if_unauthorized_to_view(session)
    erb :'notes/show'
  end
  
  get '/notes/:id/edit' do
    redirect_to_login_if_not_logged_in(session)
    @note = Note.find_by(id: params[:id])
    redirect_to_index_if_unauthorized_to_edit(session)
    @tags = []
    if !@note.tags.empty?
      @note.tags.map do |tag|
        @tags << tag.word
      end
    end
    @tags = @tags.join(", ")
    erb :'notes/edit'
  end
  
  post '/notes' do
    # creates a new note, adds to current user
    new_note = Note.new(content: params[:content], public: params[:public])
    new_note.user = current_user(session)
    # if user submitted tags, finds or creates new tag instances
    # and associates them with the new note
    if !params[:tags].empty?
      # creates array from tags string and creates new notes
      # as long as tags are comma-separated, allows user to use spaces or not
      params[:tags].split(",").each do |tag|
        new_note.tags << Tag.find_or_create_by(word: tag.strip)
      end
    end
    
    if new_note.save
      new_note.save
      redirect to 'index'
    else
      flash[:error] = "There was an error adding a new note. Please try again"
      redirect to 'notes/new'
    end
  end
  
  patch '/notes/:id' do
    note = Note.find_by(id: params[:id])
    note.content = params[:content]
    note.public = params[:public]
    note.save
    redirect to "/notes/#{note.id}"
  end
  
  delete '/notes/:id' do
    note.delete(params[:id])
    redirect to '/index'
  end
end
