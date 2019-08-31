require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'development'
  Bundler.require(:default, :development)
else
  Bundler.require(:default)
  require 'sinatra'
end


configure :development do
    set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'RubyWC_production', pool: 2, username: 'longlong', password: 'a5879632'}
end

configure :production do
  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'RubyWC_production', pool: 2, username: 'longlong', password: 'a5879632'}
end
