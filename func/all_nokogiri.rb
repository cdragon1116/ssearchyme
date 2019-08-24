require 'nokogiri' 
require 'mechanize'   
require 'json'
require 'open-uri'
require 'benchmark'
require 'thread'

def all_get_data(keyword)
  raku_mobile_url = 'https://www.findprice.com.tw/g/'
  query_url = raku_mobile_url + keyword
  begin 
    doc = Nokogiri::HTML(open(query_url))
    page = doc.css('table.rec-tb tr')
    item_list = {}
    page.each do |item|
      item_name = item.css('a.ga').text 
      now_price = item.css('span.rec-price-20').text.gsub(/\D/, "")    
      url = 'https://www.findprice.com.tw/' + item.css('a').attr('href').text
      from_shop = item.css('span img').attr('title').text
      item_list[item_name] = {:from_shop=> from_shop,
                              :item_name=> item_name, 
                              :now_price=> now_price, 
                              :ori_price=> nil, 
                              :url=> url             }
    end
    return item_list
  rescue
    "搜索超時，請縮小關鍵字範圍"
  end
end

def all_search(keyword)
  keyword = URI::encode(keyword)
  page_num = 1
  results = {}
  next_page = true
  while next_page
    result = all_get_data(keyword + '/?i=' + page_num.to_s + '&m=28847204%2C57%2C54%2C73%2C14%2C6%2C3%2C43455509%2C38%2C53%2C3799802')
    before_size = results.size
    results = results.merge(result)
    if results.size == before_size or results.size > 100
      next_page = false
      return results
    else
        page_num += 1
    end
  end
  return results
end


  
# keyword = 'ypl'
# p all_search(keyword).size
# puts Benchmark.measure{ all_search(keyword) }



# keyword = 'ypl'
# result = all_search(keyword)
# result.size
# result = result.sort_by{|k , v| v['now_price']}
# result.each do |elem|
#   p elem[1]['now_price']
# end

# puts JSON.pretty_generate(result)