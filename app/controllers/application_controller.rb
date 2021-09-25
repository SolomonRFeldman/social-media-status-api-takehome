class ApplicationController < ActionController::API
  before_action :fetch_index_results, only: %i[index]

  def index
    render json: @results, status: 200
  end

  private

  def fetch_index_results
    @results = SocialMediaApiService.index
  rescue SocialMediaApiService::BadResponseError => error
    render json: { error: { api_name: error.api_name, message: error.message, type: 'invalid response'} }, status: 500
  end
end
