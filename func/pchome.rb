


require 'mechanize'
# require 'nokogiri'    
require 'json'
require 'open-uri'



def pchome_search(keyword)
  agent = Mechanize.new
  keyword = URI::encode(keyword)
  page = agent.get('https://ecshweb.pchome.com.tw/search/v3.3/?q=' + keyword)
  # page = Nokogiri::HTML(page.body)
  p page.css('div.col3f').text

  item_list = []
  # page.css('a.BaseGridItem__content___3LORP').each do |x|

    # item_list.push( {'from_shop'=>'yahoo購物中心',
    #               'item_name'=> item, 
    #               'now_price'=> now_price, 
    #               'ori_price'=> ori_price, 
    #               'url'=> url, 
    #               'search_time'=> "#{now_time}" })
  # end
  # return item_list
end


keyword = 'ypl'
pchome_search(keyword)
# puts JSON.pretty_generate(yahoo_serach(keyword))
# puts JSON.pretty_generate(result.select{|x| x['now_price'] > 2000})
