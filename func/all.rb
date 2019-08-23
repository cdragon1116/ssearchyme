require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'

def all_get_data(keyword)
  raku_mobile_url = 'https://www.findprice.com.tw/g/'
  query_url = raku_mobile_url + keyword

  agent = Mechanize.new
  html = agent.get(query_url)
  # page.encoding = 'utf-8'
  pages = html.css('table.rec-tb tr')

  item_list = []
  pages.each do |x|
    item_name = x.css('a.ga').text
    now_price = x.css('span.rec-price-20').text.sub(',','').sub('$','').to_i
    url = 'https://www.findprice.com.tw/' + x.css('a').attr('href').text
    from_shop = x.css('span img').attr('title').text

    item_list.push( 
       {'from_shop'=> from_shop,
        'item_name'=> item_name, 
        'now_price'=> now_price, 
        'ori_price'=> nil, 
        'url'=> url, })

  end
  return item_list
end

def all_search(keyword)
  keyword = URI::encode(keyword)
  page_num = 1
  results = []
  next_page = true
  while next_page
    result = all_get_data(keyword + '/?i=' + page_num.to_s + '&m=57%2C3%2C54%2C73%2C14%2C3799802%2C28847204%2C6%2C53115987%2C61%2C70814319%2C24476286%2C97176270%2C29021742%2C38%2C2%2C43455509%2C5714195%2C43')
    results += result
    if result.size == 0 or results.size > 150
        next_page = false
        return results
    else
        page_num += 1
    end
  end
  return results
end

# keyword = 'acer'
# result = all_search(keyword)
# puts JSON.pretty_generate(result)