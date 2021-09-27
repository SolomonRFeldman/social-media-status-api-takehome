class ApplicationController < ActionController::API
  rescue_from SocialMediaApiService::BadResponseError do |error|
    render(**internal_server_error(error, 'bad response'))
  end
  rescue_from SocialMediaApiService::TimeoutError do |error|
    render(**internal_server_error(error, 'timeout'))
  end

  def index
    render json: SocialMediaApiService.index, status: 200
  end

  private

  def internal_server_error(error, type)
    {
      json: { 
        error: { 
          service_name: error.service_name, 
          message: error.message, 
          type: type
        } 
      }, 
      status: 500
    }
  end
end
