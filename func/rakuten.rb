require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'
require 'benchmark'
require 'thread'


def raku_search(keyword)
  keyword = URI::encode(keyword)
  raku_mobile_url = 'https://www.rakuten.com.tw/search/'
  query_url = raku_mobile_url + keyword
  item_list = {}
  threads = (1..2).map do |page|
    worker = Thread.new(page) do |page|
      begin 
        # puts "page -- #{page}"
        doc = Nokogiri::HTML(open(query_url +  "?p=#{page}"))
        rows = doc.css('ul.b-mod-item-list-box')
        rows.each do |row|
          items = row.css('li.b-item')
          items.each do |item|
            item_name = item.css('a.product-name').text
            start_price = item.css('span.b-text-prime:nth-child(1)').text.sub(',','').to_i
            end_price = item.css('span.b-text-prime:nth-child(2)').text.sub(',','').to_i
            ori_price = item.css('del').text.gsub(/\D/, "")
            start_ori_price = ori_price.split('-')[0].to_i
            end_ori_price = ori_price.split('-')[0].to_i
            url = 'https://www.rakuten.com.tw/' + item.css('a.product-thumbnail').attr('href').text
            item_list[item_name] =  
                   {:from_shop=>'樂天市場',
                    :item_name=> item_name, 
                    :now_price=> start_price, 
                    :ori_price=> start_ori_price, 
                    :url=> url, }
          end
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


# keyword = 'ypl'
# puts Benchmark.measure{raku_search(keyword)}
# result = raku_search(keyword)
# puts JSON.pretty_generate(result)