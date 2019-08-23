require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'


def m_get_data(keyword)
  momo_mobile_url = 'http://m.momoshop.com.tw/'
  momo_qurty_url = momo_mobile_url + 'mosearch/%s.html'

  parse = URI::encode(keyword)
  query_url = momo_qurty_url % parse

  agent = Mechanize.new
  agent.user_agent = 'mozilla/5.0 (Linux; Android 6.0.1; ' +
                     'Nexus 5x build/mtc19t applewebkit/537.36 (KHTML, like Gecko) ' +
                     'Chrome/51.0.2702.81 Mobile Safari/537.36'

  pages = agent.get(query_url)
  return pages
end

def momo_search(keyword)

  pages = m_get_data(keyword)

  item_list = []
  pages.css('div.directoryPrdListArea ul li').each do |page|
    item = page.css('p.prdName')
    now_price = page.css('b.price').text.sub(',','').to_i
    url = 'http://m.momoshop.com.tw' + page.css('a').attr('href')
    now_time = Time.now
    item_list << {'from_shop'=>'momo購物網',
                  'item_name'=> item, 
                  'now_price'=> now_price, 
                  'search_time'=> "#{now_time}",
                  'url'=> url ,
                }
  end
  return item_list
end


# result = get_momo('ypl').reject(&:empty?).sort_by{ |x| x['now_price'] }
# puts JSON.pretty_generate(result)