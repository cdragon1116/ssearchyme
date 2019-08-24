require 'nokogiri' 
require 'mechanize'   
require 'json'
require 'open-uri'
require 'benchmark'
require 'thread'


def Qall_all_search(keyword)
  keyword = URI::encode(keyword)
  raku_mobile_url = 'https://www.findprice.com.tw/g/'
  query_url = raku_mobile_url + keyword

  work_q = Queue.new
  (1..20).each{|page| work_q << page}
  item_list = {}
  workers = (0..10).map do
    Thread.new do 
      begin
        while page = work_q.pop(true)
          begin
            puts "page - #{page}"
            doc = Nokogiri::HTML(open(query_url +  "/?i=#{page}"))
            page = doc.css('table.rec-tb tr')
            page.each do |item|
              item_name = item.css('a.ga').text 
              item_list[item_name] = {:item_name=> item_name, }
            end
          rescue => e 
            puts "problem on page #{page}"
            puts e.inspect 
          end
        end
        puts ""
      rescue ThreadError
      end
    end
  end
  workers.map(&:join)
  return item_list
end
        

def Tall_search(keyword)
  keyword = URI::encode(keyword)
  raku_mobile_url = 'https://www.findprice.com.tw/g/'
  query_url = raku_mobile_url + keyword
  item_list = {}

  threads = (1..30).map do |page|
    Thread.new(page) do |page|
      begin 
        doc = Nokogiri::HTML(open(query_url +  "/?i=#{page}" + '&m=28847204%2C57%2C54%2C73%2C14%2C6%2C3%2C43455509%2C38%2C53%2C3799802'))
        page = doc.css('table.rec-tb tr')
        page.each do |item|
          item_name = item.css('a.ga').text
          now_price = item.css('span.rec-price-20').text.gsub(/\D/, "").to_i
          url = 'https://www.findprice.com.tw/' + item.css('a').attr('href').text
          from_shop = item.css('span img').attr('title').text
          item_list[item_name] = {:from_shop=> from_shop,
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



# keyword = 'surface go'
# result = Tall_search(keyword)
# result.each{|k,v| p v['now_price']}
# sresult = result.sort_by{|k , v| v[:now_price]}
# sresult.each do |elem|
#   p elem[1][:now_price]
# end
        
# puts JSON.pretty_generate(sresult)

