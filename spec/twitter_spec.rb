require "spec_helper"

describe "Twitter App" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  it "should provide a form for sending a tweet" do
    get '/'
    last_response.should be_ok
    last_response.body.should =~ /Tweet Now/
  end
end
