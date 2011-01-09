require File.join(File.dirname(__FILE__), '..', 'twitter.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'rspec/autorun'
# require 'rspec/interop/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

ENV["spec_config_dir"] = File.join(File.dirname(__FILE__), 'config')
