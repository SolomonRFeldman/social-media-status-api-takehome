require 'rails_helper'

RSpec.describe SocialMediaApiService, :type => :service do
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
  context "when index is called on the class with valid responding endpoints" do
    before do
      @response = SocialMediaApiService.index
    end

    it "returns a response with a hash containing the twitter, facebook, and instagram keys" do
      expect(@response).to include(:twitter)
      expect(@response).to include(:facebook)
      expect(@response).to include(:instagram)
    end

    it "returns a response with a hash containing valid twitter, facebook, and instagram data" do
      expect(@response[:twitter]).to eq(valid_twitter_data)
      expect(@response[:facebook]).to eq(valid_facebook_data)
      expect(@response[:instagram]).to eq(valid_instagram_data)
    end
  end
end