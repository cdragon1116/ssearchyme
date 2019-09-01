require 'sinatra'
require 'rubygems'
require "sinatra/activerecord"
require 'bundler/setup'

Dir.glob('./app/{helpers,controllers,models}/*.rb').each { |file| require file }
Dir.glob('./config/*.rb').each { |file| require file }


map('/') { run ApplicationController }