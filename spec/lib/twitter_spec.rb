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
    @mock_at = mock(OAuth::AccessToken)
    OAuth::Consumer.stub!(:new).with('cons_token', 'cons_secret', { :site => 'https://api.twitter.com' }).and_return(@mock_consumer)
  end

  it "should store a request token and request secret upon initialisation if they do not already exist" do
    @mock_consumer.should_receive(:get_request_token).with(:oauth_callback => 'http://bleh').and_return(@mock_rt)
    @mock_rt.should_receive(:token).and_return('tok')
    @mock_rt.should_receive(:secret).and_return('sec')

    Twitter.setup! 'cons_token', 'cons_secret', 'http://bleh'
    Twitter.first.request_token.should == 'tok'
    Twitter.first.request_secret.should == 'sec'
  end

  it "should return a record representing the existing request settings if these exist upon initialisation" do
    Twitter.create :request_token => 'abc', :request_secret => 'def'
    t = Twitter.setup! 'cons_token', 'cons_secret', 'http://bleh'
    t.request_token.should == 'abc'
    t.request_secret.should == 'def'
    Twitter.count.should == 1
  end

  it "should be able to generate an authorisation url" do
    Twitter.create :request_token => 'abc', :request_secret => 'def'
    OAuth::RequestToken.should_receive(:new).with(@mock_consumer, 'abc', 'def').and_return(@mock_rt)
    @mock_rt.should_receive(:authorize_url).and_return('https://blah')
    t = Twitter.setup! 'cons_token', 'cons_secret', 'http://bleh'
    t.authorise_url.should == 'https://blah'
  end

  it "should store details for the access token if it receives a valid authorisation code" do
    Twitter.create :request_token => 'abc', :request_secret => 'def'
    OAuth::RequestToken.should_receive(:new).with(@mock_consumer, 'abc', 'def').and_return(@mock_rt)
    @mock_rt.should_receive(:get_access_token).with(:oauth_verifier => 'verify').and_return(@mock_at)
    @mock_at.should_receive(:token).and_return('a_token')
    @mock_at.should_receive(:secret).and_return('a_secret')

    t = Twitter.setup! 'cons_token', 'cons_secret', 'http://bleh'
    t.authorise! 'verify'
    t.access_token.should == 'a_token'
    t.access_secret.should == 'a_secret'
  end

  it "should indicate if it has access token details" do
    Twitter.create :request_token => 'abc', :request_secret => 'def'
    OAuth::RequestToken.stub!(:new).with(@mock_consumer, 'abc', 'def').and_return(@mock_rt)
    @mock_rt.stub!(:get_access_token).with(:oauth_verifier => 'verify').and_return(@mock_at)
    @mock_at.stub!(:token).and_return('a_token')
    @mock_at.stub!(:secret).and_return('a_secret')

    t = Twitter.setup! 'cons_token', 'cons_secret', 'http://bleh'
    t.should_not be_authorised
    t.authorise! 'verify'
    t.should be_authorised
  end

  it "should post a message to twitter" do
    Twitter.create :request_token => 'abc', :request_secret => 'def', :access_token => 'ghi', :access_secret => 'jkl'
    OAuth::AccessToken.should_receive(:new).with(@mock_consumer, 'ghi', 'jkl').and_return(@mock_at)
    @mock_at.should_receive(:post).with("/1/statuses/update.json", :status => "Test Tweet")

    Twitter.setup!('cons_token', 'cons_secret', 'http://bleh').tweet("Test Tweet")
  end
end
