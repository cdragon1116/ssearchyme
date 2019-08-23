require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'

def m_get_data(keyword)
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
      'from_shop'=>'momo購物網',
      'item_name'=> item_name, 
      'now_price'=> now_price, 
      'ori_price'=> nil, 
      'url'=> url}
  end
  return item_list
end

def momo_search(keyword)
  keyword = URI::encode(keyword)
  page_num = 1
  results = {}
  next_page = true
  while next_page
    result = m_get_data(keyword + '/?i=' + page_num.to_s + '&m=14')
    before_size = results.size
    results.merge!(result)
    if results.size == before_size or results.size > 80
      next_page = false
      return results
    else
        page_num += 1
    end
  end
  return results
end

# keyword = 'ypl'
# result = momo_search(keyword)
# p result = result.sort_by{|k , v| k['now_price']}.reverse
# result.each do |elem|
#   p elem[1]['item_name']
# end



# puts JSON.pretty_generate(result)