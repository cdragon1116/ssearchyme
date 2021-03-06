require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'
require 'benchmark'
require 'thread'

def momo_search(keyword)
  keyword = URI::encode(keyword)
  raku_mobile_url = 'https://www.findprice.com.tw/g/'
  query_url = raku_mobile_url + keyword
  item_list = {}

  threads = (1..15).map do |page|
    Thread.new(page) do |page|
      begin 
        doc = Nokogiri::HTML(open(query_url +  "/?i=#{page}" + '&m=14'))
        page = doc.css('table.rec-tb tr')
        page.each do |item|
          item_name = item.css('a.ga').text
          now_price = item.css('span.rec-price-20').text.gsub(/\D/, "").to_i 
          url = 'https://www.findprice.com.tw/' + item.css('a').attr('href').text
          item_list[item_name] = {:from_shop=> 'momo購物網',
                                  :item_name=> item_name, 
                                  :now_price=> now_price, 
                                  :ori_price=> nil, 
                                  :url=> url             }
        end
      rescue => e
        puts "proglem on page #{page}"
        puts e.inspect
      end
    end
  end
  threads.map(&:join)
  return item_list
end

# keyword = '筆電'
# p momo_search(keyword)
# puts Benchmark.measure{momo_search(keyword)}