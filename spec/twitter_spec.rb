require "spec_helper"

describe "Twitter App" do
  include Rack::Test::Methods

  before(:each) do
    @mock_twitter = mock(Twitter, :authorised? => true)
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
end
