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

  get '/notes/my-notes' do
    redirect_to_login_if_not_logged_in(session)
    @notes = Note.where(user: current_user(session))
    @tags = current_user(session).tags.uniq
    erb :'notes/my-notes'
  end

  get '/notes/community-notes' do
    if current_user(session)
      @public_notes = Note.where("user_id != ? AND public = ?", current_user(session).id, '1')
      @popular_public_tags = Note.where(public: '1').collect{|note| note.tags}.flatten.group_by{|tag| tag.word}.sort_by{|k,v| v.size}.reverse.collect{|k,v| v[0]}
    else
      @public_notes = Note.where("public = ?", '1').reverse.take(6).reverse
      @popular_public_tags = Note.where(public: '1').collect{|note| note.tags}.flatten.group_by{|tag| tag.word}.sort_by{|k,v| v.size}.reverse.collect{|k,v| v[0]}.take(10)
    end

    erb :'notes/community-notes'
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
    redirect_to_index_if_unauthorized_to_edit_note(session)
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
    flash[:message] = "Thanks for making a note!"
    redirect to 'notes/new'
  end
  
  patch '/notes/:id' do
    @note = Note.find_by(id: params[:id])
    redirect_to_index_if_unauthorized_to_edit_note(session)
    @note.content = params[:content]
    @note.public = params[:public]
    
    if !@note.save
      flash[:error] = @note.errors.full_messages.uniq
      redirect to "notes/#{@note.id}/edit"
    end
  
    # convert new tags to array
    edited_tags_array = params[:tags].split(",")
    old_tags_array = @note.tags.collect {|tag| tag.word}
    
    # check to see if each old tag is in the edited tag array
    # if not in the array, delete it
    @note.tags.each do |tag|
      if !edited_tags_array.include?(tag.word)
        @note.tags.destroy(tag)
      end
    end

    # check to see if each edited tag is already in the tags array
    # if not, find or create it and add to this note's tags array
    edited_tags_array.each do |tag|
      if !old_tags_array.include?(tag)
        @note.tags << Tag.find_or_create_by(word: tag.downcase.strip)
      end
    end

    @note.save
    flash[:message] = "Note edited successfully"
    redirect to "/notes/#{@note.id}"
  end
  
  delete '/notes/:id' do
    @note = Note.find_by(id: params[:id])
    redirect_to_index_if_unauthorized_to_edit_note(session)
    Note.destroy(params[:id])
    flash[:message] = "Note deleted successfully"
    redirect to '/'
  end
end
