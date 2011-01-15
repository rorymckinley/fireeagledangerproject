require File.join(File.dirname(__FILE__), "../spec_helper")

describe Twitter do
  before(:each) do
    File.delete(File.join(ENV["spec_config_dir"], "access_token.yml")) if File.exists?(File.join(ENV["spec_config_dir"], "access_token.yml"))
    @access_token = { :token => '123', :secret => '456' }

    config = YAML.load_file(File.join(File.dirname(__FILE__), "../../", "config", "consumer.yml"))
    @mock_rt = mock(OAuth::RequestToken, :authorize_url => 'https://auth.twitter.com')
    @mock_consumer = mock(OAuth::Consumer, :get_request_token => @mock_rt)
    OAuth::Consumer.stub!(:new).with(config[:token], config[:secret], { :site => 'https://api.twitter.com' }).and_return(@mock_consumer)

  end

  it "should indicate if there is a valid access token" do
    twitter = Twitter.new :config => ENV["spec_config_dir"]
    twitter.should_not be_authorised

    File.open(File.join(ENV["spec_config_dir"], "access_token.yml"), 'w') { |f| YAML.dump(@access_details,f) }
    twitter.should be_authorised
  end

  it "should return the authorisation url for twitter" do
    twitter = Twitter.new :config => ENV["spec_config_dir"]
    twitter.authorise_url.should == 'https://auth.twitter.com'
  end

  it "should store authorisation details once the app has been authorised" do
    File.exists?(File.join(ENV["spec_config_dir"], "access_token.yml")).should be_false
    twitter = Twitter.new :config => ENV["spec_config_dir"]

    mock_at = mock(OAuth::AccessToken, :token => '123', :secret => '456')
    @mock_rt.stub(:get_access_token).and_return(mock_at)

    twitter.authorised!

    YAML.load_file(File.join(ENV["spec_config_dir"], "access_token.yml")).should == { :token => '123', :secret => '456' }
  end
end
