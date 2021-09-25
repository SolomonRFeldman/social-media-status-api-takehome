require 'rails_helper'

describe 'Applicaton Features', :type => :feature do
  let(:valid_twitter_data) { [{"username" => "test","tweet" => "hello world"}, {"username" => "john","tweet" => "dough"}] }
  let(:valid_facebook_data) { [{"name" => "test","status" => "hello world"}, {"name" => "john","status" => "dough"}] }
  let(:valid_instagram_data) { [{"username" => "picture","tweet" => "hello world"}, {"username" => "john","picture" => "dough"}] }

  before(:each) do
    stub_request(:get, /twitter/)
      .with(headers: { 'Accept'=>'*/*','User-Agent'=>'Ruby' })
      .to_return(
        status: 200, 
        body: valid_twitter_data.to_json, 
        headers: {}
      )
    stub_request(:get, /facebook/)
      .with(headers: { 'Accept'=>'*/*','User-Agent'=>'Ruby' })
      .to_return(
        status: 200, 
        body: valid_facebook_data.to_json, 
        headers: {}
      )
    stub_request(:get, /instagram/)
      .with(headers: { 'Accept'=>'*/*','User-Agent'=>'Ruby' })
      .to_return(
        status: 200, 
        body: valid_instagram_data.to_json, 
        headers: {}
      )
  end
  it "does not get a routing error when index is fetched" do
    expect{ page.driver.submit :get, '/', {} }.not_to raise_error(ActionController::RoutingError)
  end

  it "defines the index action" do
    expect{ page.driver.submit :get, root_path, {} }.not_to raise_error(AbstractController::ActionNotFound)
  end

  context "when index is requested with successful API calls" do
    before do
      page.driver.submit :get, '/', {}
    end

    it "returns a 200 code" do
      expect(page.status_code).to eq(200)
    end

    it "returns a JSON response with the data fetched from the apis" do
      parsed_data = JSON.parse(page.body)
      expect(parsed_data["twitter"]).to eq(valid_twitter_data)
      expect(parsed_data["facebook"]).to eq(valid_facebook_data)
      expect(parsed_data["instagram"]).to eq(valid_instagram_data)
    end

  end

end