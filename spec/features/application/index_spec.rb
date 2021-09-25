require 'rails_helper'

describe 'Applicaton Features', :type => :feature do

  it "does not get a routing error when index is fetched" do
    expect{ page.driver.submit :get, '/', {} }.not_to raise_error(ActionController::RoutingError)
  end

  it "defines the index action" do
    expect{ page.driver.submit :get, root_path, {} }.not_to raise_error(AbstractController::ActionNotFound)
  end

end