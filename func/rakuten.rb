require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'

def r_get_data(keyword)
  raku_mobile_url = 'https://www.rakuten.com.tw/search/'
  query_url = raku_mobile_url + keyword

  agent = Mechanize.new
  pages = agent.get(query_url)
  # page.encoding = 'utf-8'
  rows = pages.css('ul.b-mod-item-list-box')

  item_list = []
  rows.each do |row|
    items = row.css('li.b-item')
    items.each do |item|
      item_name = item.css('a.product-name').text
      start_price = item.css('span.b-text-prime:nth-child(1)').text.sub(',','').to_i
      end_price = item.css('span.b-text-prime:nth-child(2)').text.sub(',','').to_i
      ori_price = item.css('del').text.gsub(",", "").gsub(" ", "").gsub("\n", "").sub('元','')
      start_ori_price = ori_price.split('-')[0].to_i
      end_ori_price = ori_price.split('-')[0].to_i
      url = 'https://www.rakuten.com.tw/' + item.css('a.product-thumbnail').attr('href').text

      item_list.push( 
             {'from_shop'=>'樂天市場',
              'item_name'=> item_name, 
              'now_price'=> start_price, 
              'ori_price'=> start_ori_price, 
              'url'=> url, })
    end
  end
  return item_list
end

def raku_search(keyword)

  keyword = URI::encode(keyword)
  page_num = 1
  results = []
  next_page = true
  while next_page
    p page_num
    result = r_get_data(keyword + '?p=' + page_num.to_s)
    results += result
    if result.size == 0 or results.size > 30
        next_page = false
        return results
    else
        page_num += 1
    end
  end
  return results
end

# keyword = 'ypl'
# result = raku_search(keyword)
# puts JSON.pretty_generate(result)