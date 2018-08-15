class NotesController < ApplicationController

  post '/notes' do
    # creates a new note, adds to current user
    current_user(session).notes.build(params).save
    redirect to 'index'
  end

  get '/notes/:id' do
    @note = Note.find_by(id: params[:id])
    erb :'notes/show'
  end

  get '/notes/:id/edit' do
    @note = Note.find_by(id: params[:id])
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
