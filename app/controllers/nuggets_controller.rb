class NuggetsController < ApplicationController

  post '/nuggets' do
    binding.pry
    # creates a new nugget, adds to current user
    current_user(session).nuggets.build(params).save
    redirect to 'index'
  end

  get '/nuggets/:id' do
    @nugget = Nugget.find_by(id: params[:id])
    erb :'nuggets/show'
  end

end