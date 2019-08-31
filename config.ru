require 'sinatra/base'
require "sinatra/activerecord"
Dir.glob('./app/{helpers,controllers,models}/*.rb').each { |file| require file }
Dir.glob('./config/*.rb').each { |file| require file }


map('/') { run ApplicationController }