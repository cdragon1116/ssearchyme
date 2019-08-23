
require 'mechanize'
# require 'nokogiri'    
require 'json'
require 'open-uri'



def y_get_data(keyword)
  agent = Mechanize.new
  keyword = URI::encode(keyword)
  page = agent.get('https://tw.buy.yahoo.com/search/product?p=' + keyword)
  page = Nokogiri::HTML(page.body)
  # li = html.xpath("//li").text

  item_list = {}
  page.css('a.BaseGridItem__content___3LORP').each do |x|
    item_name = x.css('span.BaseGridItem__title___2HWui').text
    url = x.attr('href')
    price = x.css('.BaseGridItem__price___31jkj').text

    if price.split("$").length > 2
      ori_price = price.split("$")[2].sub(',','').to_i
    end

    now_price = price.split("$")[1].sub(',','').to_i
    item_list[item_name] = {
      'from_shop'=>'yahoo購物中心',
      'item_name'=> item_name, 
      'now_price'=> now_price, 
      'ori_price'=> ori_price, 
      'url'=> url}

  end
  return item_list
end

def y_get_allpage(keyword)
  page_num = 1
  results = {}
  next_page = true
  while next_page
    result = y_get_data(keyword + '&pg=' + page_num.to_s)
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

def yahoo_search(keyword)
  return y_get_allpage(keyword)
end

# keyword = 'ypl'
# result = yahoo_search(keyword)
# p result = result.sort_by{|k , v| k['now_price']}.reverse
# result.each do |elem|
#   p elem[1]['item_name']
# end