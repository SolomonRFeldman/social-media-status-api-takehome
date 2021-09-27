# Handles fetching and error handling of requested social media api data
class SocialMediaApiService
  class << self
    delegate :index, to: :new
  end

  @@social_media_apis = [
    OpenStruct.new(name: :twitter, uri: 'https://takehome.io/twitter'),
    OpenStruct.new(name: :facebook, uri: 'https://takehome.io/facebook'),
    OpenStruct.new(name: :instagram, uri: 'https://takehome.io/instagram')
  ]

  # Fetches data from every API known to the class
  # Returns hash with api name as the key to its data
  # ex. { twitter: [tweets], facebook: [posts] }
  def index
    social_media_apis.each_with_object({}) do |api, response|
      response[api.name] = fetch_api(api)
    end
  end

  private

  def social_media_apis
    @@social_media_apis
  end

  # Fetches a specific api's data and raises errors in case of failure
  # Timeout raises SocialMediaApiService::TimeoutError
  # Non-200 response and JSON parsing error raises SocialMediaApiService::BadResponseError
  def fetch_api(api)
    uri = URI(api.uri)

    request = Net::HTTP.new(uri.host, uri.port)
    request.read_timeout = 5.0 / 3
    request.max_retries = 0
    request.use_ssl = true

    resp = request.request_get(uri.path)

    raise BadStatusError.new unless resp.code == '200'

    JSON.parse(resp.body)
  rescue JSON::ParserError, BadStatusError
    raise BadResponseError.new('service returned a bad response', api.name)
  rescue Net::ReadTimeout
    raise TimeoutError.new('service timed out', api.name)
  end

  class BadStatusError < StandardError; end

  # Defines basic structure of how the class handles errors
  class ServiceError < StandardError
    attr_reader :service_name

    def initialize(message, service_name)
      super(message)
      @service_name = service_name
    end
  end

  # Inherites error structure while allowing use of specific error class names
  class TimeoutError < ServiceError; end
  class BadResponseError < ServiceError; end
end
