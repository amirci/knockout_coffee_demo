require 'sinatra/base'
require 'slim'
require 'sass'
require 'coffee-script'
require 'date'
require 'faker'
require './sass_handler'
require './coffee_handler'

module DemoKoCoffee
  
  class Website < Sinatra::Base
    use SassHandler
    use CoffeeHandler

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
  end
end
