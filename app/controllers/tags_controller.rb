class TagsController < ApplicationController

  get '/tags/:slug' do
    @tag = Tag.find_by_slug(params[:slug])
    erb :'tags/show'
  end
end
