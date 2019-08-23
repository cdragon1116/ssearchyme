require 'sinatra'
require "sinatra/reloader" if development?

require "sinatra/activerecord"
require './models/user'
require './config/environment.rb'

require_relative './func/yahoo.rb'
require_relative './func/f_momo.rb'
require_relative './func/f_rakuten.rb'  
require_relative './func/all.rb'  


class App < Sinatra::Base
  get '/result' do 
    @keyword = params[:keyword]
    @momo = momo_search(@keyword).to_a if params.has_key?("shop_m")
    @yahoo = yahoo_search(@keyword).to_a if params.has_key?("shop_y")
    @raku = raku_search(@keyword).to_a if params.has_key?("shop_r")
    @all = all_search(@keyword).to_a if params.has_key?("shop_all")
    @ary = Array(@yahoo) + Array(@momo) + Array(@raku)
    erb:result
  end

  get '/' do
    erb:form
  end
end
