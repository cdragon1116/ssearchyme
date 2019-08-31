require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'
require 'benchmark'
require 'thread'


def shopee_search(keyword)
  keyword = URI::encode(keyword)
  shopee_url = 'https://shopee.tw/mall/search?='
  query_url = shopee_url + keyword
  item_list = {}
  page = 1
  # doc = Nokogiri::HTML(open("https://shopee.tw/api/v2/search_items/?by=relevancy&keyword=ypl&limit=10&order=desc"))
  
  # result = JSON.parse(doc)
  # result["items"].each do |item|
  #   p item["name"]
  # end




  # p JSON.pretty_generate(result)
  # headers = {
  #   'User-Agent': 'Googlebot',
  #   'From': 'YOUR EMAIL ADDRESS'}
  
  agent = Mechanize.new
  agent.user_agent = 'Googlebot'
  agent.redirect_ok = false
  agent.request_headers = {
    'User-Agent'=> 'Googlebot',
    'From'=> 'YOUR EMAIL ADDRESS'}
  page = agent.get("https://shopee.tw/mall/search?=ypl&page=1")

  page.css('.shopee-search-item-result__item').each do |item|
    p "1"
  end

  # threads = (1..20).map do |page|
  #   Thread.new(page) do |page|
  #     begin 
  #       before_size = item_list.size
  #       doc = Nokogiri::HTML(open(query_url +  "/?i=#{page}" + '&m=28847204%2C57%2C54%2C73%2C14%2C6%2C3%2C43455509%2C38%2C53%2C3799802'))
  #       page = doc.css('table.rec-tb tr')
  #       page.each do |item|
  #         item_name = item.css('a.ga').text
  #         now_price = item.css('span.rec-price-20').text.gsub(/\D/, "").to_i
  #         url = 'https://www.findprice.com.tw/' + item.css('a').attr('href').text
  #         from_shop = item.css('span img').attr('title').text
  #         item_list[item_name] = {:from_shop=> from_shop,
  #                                 :item_name=> item_name, 
  #                                 :now_price=> now_price, 
  #                                 :ori_price=> nil, 
  #                                 :url=> url             }
  #       end
  #     rescue => e
  #       puts "proglem on page #{page}"
  #       puts e.inspect
  #     end
  #   end
  # end
  # threads.map(&:join)
  # return item_list
end


keyword = 'ypl'
# puts Benchmark.measure{raku_search(keyword)}
result = shopee_search(keyword)
# puts JSON.pretty_generate(result)