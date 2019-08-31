
class ApplicationController < Sinatra::Base
  helpers ApplicationHelper
  set :views, "#{settings.root}/../views"
  set :models, "#{settings.root}/../models"


  get '/result' do 
    if params[:keyword] != ""
      @keyword = params[:keyword]
    else
      redirect '/'
    end

    # @results = Tall_search(@keyword).to_a
    # @results.each do |result|
    #   Item.create(result[1])
    # end

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
