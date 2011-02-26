require File.join(File.dirname(__FILE__), '..', 'twitter.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'rspec/autorun'
require 'dm-core'
# require 'rspec/interop/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

ENV["CONSUMER_TOKEN"] = "1233"
ENV["CONSUMER_SECRET"] = "1256"
ENV["USERNAME"] = 'luser'
ENV["PASSWORD"] = 'secret'
ENV["DATABASE_URL"] = "sqlite3://#{File.join(File.dirname(__FILE__), '..', 'db', 'test.db')}"
