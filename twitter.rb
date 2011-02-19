require 'rubygems'
require 'sinatra'
require 'erb'
require File.dirname(__FILE__) + '/lib/twitter'

enable :sessions

get '/' do
  twitter = Twitter.new :config => File.join(File.dirname(__FILE__), "config" )
  if twitter.authorised?
    erb :new_tweet
  else
    @auth_url = twitter.authorise_url
    erb :authorise
  end
end

post '/oauth' do
  twitter = Twitter.new :config => File.join(File.dirname(__FILE__), "config" )
  twitter.authorise ENV["request_token"], ENV["request_secret"], params[:oauth_verifier]
  redirect '/'
end

