class TagsController < ApplicationController

  get '/my-tags' do
    @tags = current_user(session).tags.uniq
    erb :'tags/tags'
  end

  get '/public-tags' do
    @public_tags = Note.where(public: '1').collect do |note|
      note.tags
    end.flatten.sort.group_by{|tag| tag.word}.sort_by{|k,v| v.size}.reverse.collect{|k,v| v[0]}
    erb :'/tags/public_tags'
  end

  get '/tags/:slug' do
    @tag = Tag.find_by_slug(params[:slug])
    @user_notes = @tag.notes.where(user: current_user(session))
    @community_notes = @tag.notes.where("user_id != ? AND public = ?", current_user(session).id, '1')
    erb :'tags/show'
  end
end
