require "spec_helper"
require "uri"

describe "Twitter App" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
    @app.send(:set, :sessions, false)
  end

  context "Unauthorised" do
    it "should not allow unauthorised access to the application" do
      get '/'
      last_response.status.should == 401
    end
  end

  context "Authorised" do
    before(:each) do
      @mock_twitter = mock(Twitter, :authorised! => true, :authorised? => true)
      Twitter.should_receive(:setup!).with(ENV["CONSUMER_TOKEN"], ENV["CONSUMER_SECRET"], "http://example.org/oauth").and_return(@mock_twitter)
      authorize ENV['USERNAME'], ENV['PASSWORD']
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
      @mock_twitter.should_receive(:authorise!).with('12345')
      get '/oauth', :oauth_verifier => '12345'
    end

    it "should return the user to the page to post a tweet after receiving authorisation" do
      @mock_twitter.stub!(:authorise!)
      get '/oauth', :oauth_verifier => '12345'
      last_response.status.should == 302
      URI.parse(last_response.headers['Location']).path.should == "/"
    end

    it "should provide a way to post a tweet" do
      @mock_twitter.should_receive(:tweet).with('Hello, from Twitter')
      post '/tweet', :tweet => { "content" => 'Hello, from Twitter' }
    end

    it "should redirect to the start page after tweeting" do
      @mock_twitter.stub!(:tweet)
      post '/tweet', :tweet => { "content" => 'Hello, from Twitter' }
      last_response.status.should == 302
      URI.parse(last_response.headers['Location']).path.should == "/"
    end
  end

end
