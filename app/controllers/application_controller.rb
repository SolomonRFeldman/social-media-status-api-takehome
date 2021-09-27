# Controller that contains a single root index action for rendering SocialMediaApiService.index
class ApplicationController < ActionController::API
  rescue_from SocialMediaApiService::BadResponseError do |error|
    render(**internal_server_error(error, 'bad response'))
  end
  rescue_from SocialMediaApiService::TimeoutError do |error|
    render(**internal_server_error(error, 'timeout'))
  end

  # Renders the hash SocialMediaApiService.index
  # converted to JSON with each api name as a key
  # ex. '{"twitter":[tweets], "facebook":[posts]}'
  def index
    render json: SocialMediaApiService.index, status: 200
  end

  private

  # Builds parameters to render for an internal server error as a hash
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
