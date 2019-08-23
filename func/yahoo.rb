
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

  item_list = []
  page.css('a.BaseGridItem__content___3LORP').each do |x|
    item = x.css('span.BaseGridItem__title___2HWui').text
    url = x.attr('href')
    price = x.css('.BaseGridItem__price___31jkj').text

    if price.split("$").length > 2
      ori_price = price.split("$")[2].sub(',','').to_i
    end

    now_price = price.split("$")[1].sub(',','').to_i
    now_time = Time.now
    item_list.push( {'from_shop'=>'yahoo購物中心',
                  'item_name'=> item, 
                  'now_price'=> now_price, 
                  'ori_price'=> ori_price, 
                  'url'=> url, 
                  'search_time'=> "#{now_time}" })
  end
  return item_list
end

def y_get_allpage(keyword)
  page_num = 1
  results = []
  next_page = true
  while next_page
    result = y_get_data(keyword + '&pg=' + page_num.to_s)
    results += result
    if result.size == 0 or results.size > 50
        next_page = false
        return results
    else
        page_num += 1
    end
  end
  return results
end

def yahoo_search(keyword)
  return y_get_allpage(keyword).reject(&:empty?)
end

# keyword = 'ypl'
# yahoo_serach(keyword)
# puts JSON.pretty_generate(yahoo_serach(keyword))
# puts JSON.pretty_generate(result.select{|x| x['now_price'] > 2000})
