module ApplicationHelper
  Dir.glob('./app/{helpers}/*.rb').each { |file| require file }
end