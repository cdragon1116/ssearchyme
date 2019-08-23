require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'

def r_get_data(keyword)
  raku_mobile_url = 'https://www.findprice.com.tw/g/'
  query_url = raku_mobile_url + keyword

  agent = Mechanize.new
  html = agent.get(query_url)
  # page.encoding = 'utf-8'
  pages = html.css('table.rec-tb tr')
  item_list = {}
  pages.each do |x|
    item_name = x.css('a.ga').text 
    now_price = x.css('span.rec-price-20').text.sub(',','').sub('$','').to_i
    url = 'https://www.findprice.com.tw/' + x.css('a').attr('href').text
    
    item_list[item_name] = {
      'from_shop'=>'樂天市場',
      'item_name'=> item_name, 
      'now_price'=> now_price, 
      'ori_price'=> nil, 
      'url'=> url}
  end
  return item_list
end

def raku_search(keyword)
  keyword = URI::encode(keyword)
  page_num = 1
  results = {}
  next_page = true
  while next_page
    result = r_get_data(keyword + '/?i=' + page_num.to_s + '&m=28847204')
    before_size = results.size
    results.merge!(result)
    if results.size == before_size or result.size == 0 or results.size > 50
      next_page = false
      return results
    else
        page_num += 1
    end
  end
  return results
end

# keyword = '水光針'
# result = raku_search(keyword)
# p result = result.sort_by{|k , v| k['now_price']}.reverse
# result.each do |elem|
#   p elem[1]['item_name']
# end



# puts JSON.pretty_gener
# ate(result)
