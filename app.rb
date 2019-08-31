require 'sinatra'
require "sinatra/reloader" if development?

require "sinatra/activerecord"
require './models/user'
require './config/environment.rb'

require_relative './helper/yahoo.rb'
require_relative './helper/f_yahoob.rb'
require_relative './helper/f_momo.rb'
require_relative './helper/f_rakuten.rb'  
require_relative './helper/f_shopee.rb'  
require_relative './helper/all_thread.rb'  


class App < Sinatra::Base
  get '/result' do 
    if params[:keyword] != ""
      @keyword = params[:keyword]
    else
      redirect '/'
    end

    if params[:shop]
        @momo = momo_search(@keyword).to_a if params[:shop].has_key?("shop_m")
        @yahoo = yahoo_search(@keyword).to_a if params[:shop].has_key?("shop_y")
        @raku = raku_search(@keyword).to_a if params[:shop].has_key?("shop_r")
        @shop = shop_search(@keyword).to_a if params[:shop].has_key?("shop_s")
        @yahoob = yahoob_search(@keyword).to_a if params[:shop].has_key?("shop_yb")
        @ary = Array(@yahoo) + Array(@momo) + Array(@raku) + Array(@shop) + Array(@yahoob)
    else
      @ary = Tall_search(@keyword).to_a
    end

    @ary.sort_by!{|k , v| v[:now_price]}
    erb:result
  end

  get '/' do

    erb:form
  end
end



     
