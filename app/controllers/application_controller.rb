class ApplicationController < ActionController::API
  def index
    render json: SocialMediaApiService.index, status: 200
  end
end
