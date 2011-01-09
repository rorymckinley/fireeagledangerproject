require 'oauth'
require 'oauth/consumer'

class Twitter
  def initialize(options={})
    @config = options[:config]
  end

  def authorised?
    File.exists? File.join(@config, "access_token.yml")
  end

  def authorise_url
    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'consumer.yml'))
    consumer = OAuth::Consumer.new(config[:token], config[:secret], { :site => 'https://api.twitter.com' })
    consumer.get_request_token.authorize_url
  end

  def authorised!
    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'consumer.yml'))
    consumer = OAuth::Consumer.new(config[:token], config[:secret], { :site => 'https://api.twitter.com' })
    access_token = consumer.get_request_token.get_access_token
    File.open(File.join(@config, "access_token.yml"), 'w') { |f| YAML.dump({ :token => access_token.token, :secret => access_token.secret }) }
  end
end
