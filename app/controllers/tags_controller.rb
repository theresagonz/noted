class TagsController < ApplicationController

  get '/tags' do
    @tags = current_user(session).tags.uniq
    erb :'tags/tags'
  end

  get '/tags/public' do
    @public_tags = Note.where(public: '1').collect do |note|
      note.tags
    end.flatten.sort.group_by{|tag| tag.word}.sort_by{|k,v| v.size}.reverse.collect{|k,v| v[0]}
    erb :'/tags/public_tags'
  end

  get '/tags/:slug' do
    @tag = Tag.find_by_slug(params[:slug])
    erb :'tags/show'
  end
end
