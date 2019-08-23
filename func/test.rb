require 'mechanize'
require 'nokogiri'    
require 'json'
require 'open-uri'
require 'pry'

agent = Mechanize.new  
agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36"


data = {"searchKeyword": "ypl",
"couponSeq": "",
"searchType": 1,
"cateLevel": -1,
"ent": "k",
"_imgSH": "fourCardStyle"}
# p page = agent.get("https://www.momoshop.com.tw/search/",data,{'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'}) 
# p page.css("ul li")



p page = agent.post(
  'https://m.momoshop.com.tw/main.momo', 
  data, 
  {'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'},
)

