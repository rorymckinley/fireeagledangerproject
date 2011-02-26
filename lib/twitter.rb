require 'oauth'
require 'oauth/consumer'
require 'yaml'
require 'dm-core'

class Twitter
  include DataMapper::Resource

  property :request_token, String
  property :request_secret, String
  property :access_token, String
  property :access_secret, String

  storage_names[:default] = 'twitter'

  def self.setup!(consumer_token, consumer_secret, callback_url)
    unless t = Twitter.first
      request = OAuth::Consumer.new(consumer_token, consumer_secret, { :site => 'https://api.twitter.com' }).get_request_token(:oauth_callback => callback_url)
      t = Twitter.create :request_token => request.token, :request_secret => request.secret
    end
    t.set_consumer_details  consumer_token, consumer_secret
    t
  end

  def authorise!(auth_verification)
    rt = OAuth::RequestToken.new(OAuth::Consumer.new(@consumer_token, @consumer_secret, { :site => 'https://api.twitter.com' }), self.request_token, self.request_secret)
    at = rt.get_access_token(:oauth_verifier => auth_verification)
    self.access_token = at.token
    self.access_secret = at.secret
    save
  end

  def authorised?
    self.access_token && self.access_secret
  end

  def authorise_url
    OAuth::RequestToken.new(OAuth::Consumer.new(@consumer_token, @consumer_secret, { :site => 'https://api.twitter.com' }), self.request_token, self.request_secret).authorize_url
  end

  def authorised!
    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'consumer.yml'))
    consumer = OAuth::Consumer.new(config[:token], config[:secret], { :site => 'https://api.twitter.com' })
    rt= consumer.get_request_token
    at = rt.get_access_token(:oauth_verifier => '8341349')
    # access_token = consumer.get_request_token.get_access_token
    # File.open(File.join(@config, "access_token.yml"), 'w') { |f| f.write(YAML.dump({ :token => access_token.token, :secret => access_token.secret })) }
  end

  def set_consumer_details(consumer_token, consumer_secret)
    @consumer_token, @consumer_secret = consumer_token, consumer_secret
  end

  def tweet(message)
    at = OAuth::AccessToken.new(OAuth::Consumer.new(@consumer_token, @consumer_secret, { :site => 'https://api.twitter.com' }), self.access_token, self.access_secret)
    r = at.post "/1/statuses/update.json", :status => message
    puts r.body
  end
end
