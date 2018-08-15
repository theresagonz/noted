class NuggetsController < ApplicationController

  post '/nuggets' do
    # creates a new nugget, adds to current user
    current_user(session).nuggets.build(params).save
    redirect to 'index'
  end

  get '/nuggets/:id' do
    @nugget = Nugget.find_by(id: params[:id])
    erb :'nuggets/show'
  end

  get '/nuggets/:id/edit' do
    @nugget = Nugget.find_by(id: params[:id])
    erb :'nuggets/edit'
  end
  
  delete '/nuggets/:id' do
    Nugget.delete(params[:id])
    redirect to '/index'
  end

  patch '/nuggets/:id' do
    nugget = Nugget.find_by(id: params[:id])
    nugget.content = params[:content]
    nugget.public = params[:public]
    nugget.save
    redirect to "/nuggets/#{nugget.id}"
  end

end
