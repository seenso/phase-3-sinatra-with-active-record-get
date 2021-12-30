class ApplicationController < Sinatra::Base
  #Sinatra defaults Content-Type to 'text/html' so setting it to app/json here
  set :default_content_type, 'application/json'

  get '/' do
    { message: "Hello world" }.to_json
  end

  get '/games' do
    #alphabetize game list by title and then return the first 10 in json format.
    Game.all.order(:title).limit(10).to_json
  end

  # use the :id syntax to create a dynamic route
  get '/games/:id' do
    # look up the game in the database using its ID
    game = Game.all.find(params[:id])
    # send a JSON-formatted response of the game data and include reviews with user info
    #.to_json() uses .as_json() under the hood, and .as_json() has optional params that we can include per documentation.
    ## https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html#method-i-as_json
    game.to_json(include: {
      reviews: { include: :user }
    })
  end

end
