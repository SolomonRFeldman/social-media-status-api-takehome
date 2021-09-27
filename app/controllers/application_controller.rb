class ApplicationController < ActionController::API
  rescue_from SocialMediaApiService::BadResponseError do |error|
    render(
      json: { 
        error: { 
          service_name: error.service_name, 
          message: error.message, 
          type: 'bad response'
        } 
      }, 
      status: 500
    )
  end

  def index
    render json: SocialMediaApiService.index, status: 200
  end
end
