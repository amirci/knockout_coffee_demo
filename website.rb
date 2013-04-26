require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/json'
require 'slim'
require 'sass'
require 'coffee-script'
require 'date'
require 'faker'
require './sass_handler'
require './coffee_handler'
require 'ostruct'

module DemoKoCoffee
  
  class Website < Sinatra::Base
    use SassHandler
    use CoffeeHandler
    helpers Sinatra::ContentFor
    helpers Sinatra::JSON

    configure :test do
      # enable :logging
      set :delivery_method, :test
    end

    set :public_folder, File.dirname(__FILE__) + '/public'
    set :views, File.dirname(__FILE__) + '/views'

    get '/' do
      redirect to :home
    end
    
    get '/home' do
      slim :home
    end
    
    get '/movies.json' do
      movies = [
        {title: 'Blazing Saddles', release: Date.new(1974, 2, 7)},
        {title: 'Young Frankenstain', release: Date.new(1974, 12, 15)},
        {title: 'Spaceballs', release: Date.new(1987, 6, 24)}
      ]
      json movies: movies
    end
    
    get '/demo' do
      slim :demo
    end
    
    get '/twitter_demo' do
      slim :twitter_demo
    end
  end
end
