require 'rubygems'
require 'sinatra'
require 'erb'
require 'dm-core'
require File.dirname(__FILE__) + '/lib/twitter'

use Rack::Auth::Basic, "" do |username, password|
  [username, password] == [ENV['USERNAME'],ENV['PASSWORD']]
end

DataMapper.setup(:default, ENV['DATABASE_URL'])

get '/' do
  twitter = Twitter.setup! ENV["CONSUMER_TOKEN"], ENV["CONSUMER_SECRET"], "#{request.scheme}://#{request.host}/oauth"
  if twitter.authorised?
    erb :new_tweet
  else
    @auth_url = twitter.authorise_url
    erb :authorise
  end
end

get '/oauth' do
  twitter = Twitter.setup! ENV["CONSUMER_TOKEN"], ENV["CONSUMER_SECRET"], "#{request.scheme}://#{request.host}/oauth"
  twitter.authorise params[:oauth_verifier]
  redirect '/'
end

post '/tweet' do
  twitter = Twitter.setup! ENV["CONSUMER_TOKEN"], ENV["CONSUMER_SECRET"], "#{request.scheme}://#{request.host}/oauth"
  twitter.tweet params[:message]
  redirect '/'
end

