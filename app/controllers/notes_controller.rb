class NotesController < ApplicationController
  get '/notes' do
    @notes = Note.where(user: current_user(session))
    erb :'notes/notes'
  end

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

    # if no content submimtted, redirect to new note page with validation error
    if !new_note.save
      flash[:error] = new_note.errors.full_messages.uniq
      redirect to 'notes/new'
    end

    # if user submitted tags, finds or creates new tag instances
    # and associates them with the new note
    if !params[:tags].empty?
      # creates array from tags string and creates new notes
      # as long as tags are comma-separated, allows user to use spaces or not
      params[:tags].split(",").each do |tag|
        new_note.tags << Tag.find_or_create_by(word: tag.downcase.strip)
      end
    end

    new_note.save
    flash[:message] = "Note created successfully"
    redirect to 'index'
  end
  
  patch '/notes/:id' do
    note = Note.find_by(id: params[:id])
    note.content = params[:content]
    note.public = params[:public]
    
    if !note.save
      flash[:error] = note.errors.full_messages.uniq
      redirect to "notes/#{note.id}/edit"
    end
  
    # convert new tags to array
    edited_tag_array = params[:tags].split(",")
    old_tag_array = note.tags.collect {|tag| tag.word}
    
    # check to see if each old tag is in the edited tag array
    # if not in the array, delete it
    note.tags.each do |tag|
      if !edited_tag_array.include?(tag.word)
        note.tags.delete(tag)
      end
    end

    # check to see if each edited tag is already in the tags array
    # if not, find or create it and add to this note's tags array
    edited_tag_array.each do |tag|
      if !old_tag_array.include?(tag)
        note.tags << Tag.find_or_create_by(word: tag.downcase.strip)
      end
    end

    note.save
    flash[:message] = "Note edited successfully"
    redirect to "/notes/#{note.id}"
  end
  
  delete '/notes/:id' do
    Note.delete(params[:id])
    flash[:message] = "Note deleted successfully"
    redirect to '/index'
  end
end
