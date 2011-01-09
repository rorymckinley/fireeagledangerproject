require 'rubygems'
require 'sinatra'
require 'erb'
require File.dirname(__FILE__) + '/lib/twitter'

get '/' do
  twitter = Twitter.new :config => File.join(File.dirname(__FILE__), "config" )
  if twitter.authorised?
    erb :new_tweet
  else
    @auth_url = twitter.authorise_url
    erb :authorise
  end
end

post '/authorise' do
  twitter = Twitter.new :config => File.join(File.dirname(__FILE__), "config" )
  twitter.authorised!
  "ok"
end
