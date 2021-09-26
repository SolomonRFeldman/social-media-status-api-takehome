class ApplicationController < ActionController::API
  rescue_from SocialMediaApiService::BadResponseError do |error|
    render(
      json: { 
        error: { 
          api_name: error.api_name, 
          message: error.message, 
          type: 'invalid response'
        } 
      }, 
      status: 500
    )
  end

  def index
    render json: SocialMediaApiService.index, status: 200
  end
end
