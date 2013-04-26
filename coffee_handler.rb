require 'sinatra/base'

class CoffeeHandler < Sinatra::Base
    set :views, File.dirname(__FILE__) + '/templates/coffee'
    
    get "/js/*.js" do
        filename = params[:splat].first
        coffee filename.to_sym
    end
end

