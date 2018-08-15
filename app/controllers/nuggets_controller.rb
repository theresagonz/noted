class NuggetsController < ApplicationController

  post '/nuggets' do
    binding.pry
    # creates a new nugget, adds to current user
    current_user(session).nuggets.build(params).save
    redirect to 'index'
  end

end