require 'sinatra/base'

class SassHandler < Sinatra::Base
    
    set :views, File.dirname(__FILE__) + '/templates/sass'
    
    get '/css/*.css' do
        filename = params[:splat].first
        scss filename.to_sym
    end
    
end

