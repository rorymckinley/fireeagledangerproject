require 'rubygems'
require 'sinatra'
require 'erb'

get '/' do
  erb :new_tweet
end
