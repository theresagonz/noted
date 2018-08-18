class TagsController < ApplicationController

  get '/tags' do
    @tags = current_user(session).tags.uniq
    erb :'tags/tags'
  end

  get '/tags/:slug' do
    @tag = Tag.find_by_slug(params[:slug])
    erb :'tags/show'
  end
end
