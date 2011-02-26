require 'rubygems'
require 'sinatra'
require 'erb'
require 'dm-core'
require File.dirname(__FILE__) + '/lib/twitter'

get '/' do
  twitter = Twitter.setup! ENV["CONSUMER_TOKEN"], ENV["CONSUMER_SECRET"]
  if twitter.authorised?
    erb :new_tweet
  else
    @auth_url = twitter.authorise_url
    erb :authorise
  end
end

post '/oauth' do
  twitter = Twitter.setup! ENV["CONSUMER_TOKEN"], ENV["CONSUMER_SECRET"]
  twitter.authorise params[:oauth_verifier]
  redirect '/'
end

post '/tweet' do
  twitter = Twitter.setup! ENV["CONSUMER_TOKEN"], ENV["CONSUMER_SECRET"]
  twitter.tweet params[:message]
  redirect '/'
end

