require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'development'
  Bundler.require(:default, :development)
else
  Bundler.require(:default)
  require 'sinatra'
end


configure :development do
  set :database, 'sqlite3:db/database.db'
end
