require "spec_helper"
require "uri"

describe "Twitter App" do
  include Rack::Test::Methods

  before(:each) do
    @mock_twitter = mock(Twitter, :authorised! => true, :authorised? => true)
    Twitter.should_receive(:new).and_return(@mock_twitter)
  end

  def app
    @app ||= Sinatra::Application
    @app.send(:set, :sessions, false)
  end

  it "should provide a form for sending a tweet" do
    get '/'
    last_response.should be_ok
    last_response.body.should =~ /Tweet Now/
  end

  it "should prompt the user to visit the authorisation link if they have not authorised the app" do
    @mock_twitter.should_receive(:authorised?).and_return(false)
    @mock_twitter.should_receive(:authorise_url).and_return("https://path/to/auth")
    get '/'
    last_response.should be_ok
    last_response.body.should =~ /Authorise Application/
    last_response.body.should =~ /https:\/\/path\/to\/auth/
  end

  it "should provide a callback to handle the oauth response from the auth url" do
    ENV['request_token'] = 'req_token'
    ENV['request_secret'] = 'req_secret'
    @mock_twitter.should_receive(:authorise).with('req_token', 'req_secret', '12345')
    post '/oauth', :oauth_verifier => '12345'
  end

  it "should return the user to the page to post a tweet after receiving authorisation" do
    @mock_twitter.stub!(:authorise)
    post '/oauth', :oauth_verifier => '12345'
    last_response.status.should == 302
    URI.parse(last_response.headers['Location']).path.should == "/"
  end
end
