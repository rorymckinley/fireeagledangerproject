require File.join(File.dirname(__FILE__), "../spec_helper")

describe Twitter do
  before(:all) do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end

  before(:each) do
    Twitter.all.destroy
    config = YAML.load_file(File.join(File.dirname(__FILE__), "../../", "config", "consumer.yml"))
    @mock_rt = mock(OAuth::RequestToken, :authorize_url => 'https://auth.twitter.com')
    @mock_consumer = mock(OAuth::Consumer, :get_request_token => @mock_rt)
    OAuth::Consumer.stub!(:new).with('cons_token', 'cons_secret', { :site => 'https://api.twitter.com' }).and_return(@mock_consumer)
  end

  it "should store a request token and request secret upon initialisation if they do not already exist" do
    @mock_rt.should_receive(:token).and_return('tok')
    @mock_rt.should_receive(:secret).and_return('sec')

    Twitter.setup! 'cons_token', 'cons_secret'

    Twitter.first.request_token.should == 'tok'
    Twitter.first.request_secret.should == 'sec'
  end

  it "should return a record representing the existing request settings if these exist upon initialisation" do
    Twitter.create :request_token => 'abc', :request_secret => 'def'
    t = Twitter.setup! 'cons_token', 'cons_secret'
    t.request_token.should == 'abc'
    t.request_secret.should == 'def'
    Twitter.count.should == 1
  end

  it "should be able to generate an authorisation url" do
    Twitter.create :request_token => 'abc', :request_secret => 'def'
    OAuth::RequestToken.should_receive(:new).with(@mock_consumer, 'abc', 'def').and_return(@mock_rt)
    @mock_rt.should_receive(:authorize_url).and_return('https://blah')
    t = Twitter.setup! 'cons_token', 'cons_secret'
    t.authorise_url.should == 'https://blah'
  end

  it "should indicate if there is a valid access token" do
    pending
    twitter = Twitter.new :config => ENV["spec_config_dir"]
    twitter.should_not be_authorised

    File.open(File.join(ENV["spec_config_dir"], "access_token.yml"), 'w') { |f| YAML.dump(@access_details,f) }
    twitter.should be_authorised
  end

  it "should return the authorisation url for twitter" do
    pending
    twitter = Twitter.new :config => ENV["spec_config_dir"]
    twitter.authorise_url.should == 'https://auth.twitter.com'
  end

  it "should store authorisation details once the app has been authorised" do
    pending
    File.exists?(File.join(ENV["spec_config_dir"], "access_token.yml")).should be_false
    twitter = Twitter.new :config => ENV["spec_config_dir"]

    mock_at = mock(OAuth::AccessToken, :token => '123', :secret => '456')
    @mock_rt.stub(:get_access_token).and_return(mock_at)

    twitter.authorised!

    YAML.load_file(File.join(ENV["spec_config_dir"], "access_token.yml")).should == { :token => '123', :secret => '456' }
  end
end
