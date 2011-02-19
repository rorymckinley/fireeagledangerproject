require 'oauth'
require 'oauth/consumer'
require 'yaml'
require 'dm-core'

class Twitter
  include DataMapper::Resource

  property :request_token, String
  property :request_secret, String
  property :oauth_verification, String

  storage_names[:default] = 'twitter'

  # def initialize(consumer_token, consumer_secret)
  #   request = OAuth::Consumer.new(consumer_token, consumer_secret, { :site => 'https://api.twitter.com' }).get_request_token
  #   self.request_token = request.token
  #   self.request_secret = request.secret
  #   self.save
  # end

  def self.setup!(consumer_token, consumer_secret)
    unless t = Twitter.first
      request = OAuth::Consumer.new(consumer_token, consumer_secret, { :site => 'https://api.twitter.com' }).get_request_token
      t = Twitter.create :request_token => request.token, :request_secret => request.secret
    end
    t
  end

  def authorised?
    File.exists? File.join(@config, "access_token.yml")
  end

  def authorise_url
    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'consumer.yml'))
    puts config.inspect
    consumer = OAuth::Consumer.new(config[:token], config[:secret], { :site => 'https://api.twitter.com' })
    consumer.get_request_token.authorize_url
  end

  def authorised!
    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'consumer.yml'))
    consumer = OAuth::Consumer.new(config[:token], config[:secret], { :site => 'https://api.twitter.com' })
    rt= consumer.get_request_token
    at = rt.get_access_token(:oauth_verifier => '8341349')
    # access_token = consumer.get_request_token.get_access_token
    # File.open(File.join(@config, "access_token.yml"), 'w') { |f| f.write(YAML.dump({ :token => access_token.token, :secret => access_token.secret })) }
  end
end
