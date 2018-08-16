class NotesController < ApplicationController

  post '/notes' do
    # creates a new note, adds to current user
    new_note = Note.new(content: params[:content], public: params[:public])
    new_note.user = current_user(session)
    # if user entered tags, create new tag objects and associate them with the note
    if !params[:tags].empty?
      params[:tags].split.each do |tag|
        new_note.tags << Tag.find_or_create_by(word: tag)
      end
    end

    if new_note.save
      new_note.save
      binding.pry
      redirect to 'index'
    else
      flash[:error] = "There was an error adding a new note. Please try again"
      redirect to 'notes/new'
    end
  end

  get '/notes/new' do
    redirect_if_not_logged_in(session)
    erb :'notes/new'
  end

  get '/notes/:id' do
    redirect_if_not_logged_in(session)
    @note = Note.find_by(id: params[:id])
    erb :'notes/show'
  end

  get '/notes/:id/edit' do
    @note = Note.find_by(id: params[:id])
    @tags = []
    if !@note.tags.empty?
      @note.tags.map do |tag|
        @tags << tag.word
      end
    end
    @tags = @tags.join(" ")
    erb :'notes/edit'
  end
  
  delete '/notes/:id' do
    note.delete(params[:id])
    redirect to '/index'
  end

  patch '/notes/:id' do
    note = Note.find_by(id: params[:id])
    note.content = params[:content]
    note.public = params[:public]
    note.save
    redirect to "/notes/#{note.id}"
  end

end
