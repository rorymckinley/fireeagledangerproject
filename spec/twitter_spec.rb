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

  it "should provide a link so that the user can indicate when he has authorised the application" do
    @mock_twitter.should_receive(:authorised?).and_return(false)
    @mock_twitter.should_receive(:authorise_url).and_return("https://path/to/auth")
    get '/'
    last_response.body.should =~ /Confirm Authorisation/
  end

  it "should allow the user to confirm that the app is authorised" do
    @mock_twitter.should_receive(:authorised!)
    post '/authorise'
  end

  it "should redirect the user to the formto post a tweet once he has confirmed authorisation" do
    post '/authorise'
    last_response.status.should == 302
    URI.parse(last_response.headers['Location']).path.should == "/"
  end
end
