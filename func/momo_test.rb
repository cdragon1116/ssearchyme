require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'

# def m_get_allpage(keyword)
#   page_num = 1
#   results = []
#   next_page = true
#   while next_page
#     p keyword + '&curPage=' + page_num.to_s
#     p result = m_get_data(keyword + '&curPage=' + page_num.to_s)
#     results += result
#     if result.size == 0 or results.size > 50
#         next_page = false
#         return results
#     else
#         page_num += 1
#     end
#   end
#   return results

# end


def m_get_data(keyword)
  parse = URI::encode(keyword)
  query_url = "https://m.momoshop.com.tw/search.momo?searchKeyword=ypl&curPage=3"

  agent = Mechanize.new
  agent.user_agent = 'mozilla/5.0 (Linux; Android 6.0.1; ' +
                     'Nexus 5x build/mtc19t applewebkit/537.36 (KHTML, like Gecko) ' +
                     'Chrome/51.0.2702.81 Mobile Safari/537.36'

  p pages = agent.get("https://www.momoshop.com.tw/search/searchShop.jsp?keyword=ypl")

  item_list = []
  pages.css('li.goodsItemLi').each do |page|
    item = page.css('p.prdName').text.gsub(' ','').gsub("\r\n",'')
    now_price = page.css('b.price').text.sub(',','').sub('$','')
    url = 'http://m.momoshop.com.tw' + page.css('a').first.attr('href')
    now_time = Time.now
    item_list << {'from_shop'=>'momo購物網',
                  'item_name'=> item, 
                  'now_price'=> now_price, 
                  'search_time'=> "#{now_time}",
                  'url'=> url ,
                }
  end
  item_list
  return item_list
end

def momo_search(keyword)
  pages = m_get_allpage(keyword)
end


# m_get_data('ypl')
puts JSON.pretty_generate(m_get_data('ypl'))