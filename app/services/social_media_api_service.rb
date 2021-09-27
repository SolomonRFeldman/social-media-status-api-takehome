
class SocialMediaApiService
  class << self
    delegate :index, to: :new
  end

  @@social_media_apis = [
    OpenStruct.new(name: :twitter, uri: 'https://takehome.io/twitter'),
    OpenStruct.new(name: :facebook, uri: 'https://takehome.io/facebook'),
    OpenStruct.new(name: :instagram, uri: 'https://takehome.io/instagram')
  ]

  def index
    social_media_apis.each_with_object({}) do |api, response|
      response[api.name] = fetch_api(api)
    end
  end

  private

  def social_media_apis
    @@social_media_apis
  end

  def fetch_api(api)
    uri = URI(api.uri)

    request = Net::HTTP.new(uri.host, uri.port)
    request.read_timeout = 5.0 / 3
    request.max_retries = 0
    request.use_ssl = true
 
    resp = request.request_get(uri.path)

    raise BadStatusError.new unless resp.code == "200"

    JSON.parse(resp.body)
  rescue JSON::ParserError, BadStatusError
    raise BadResponseError.new('api returned an invalid response', api.name)
  rescue Net::ReadTimeout
    raise TimeoutError.new('service timed out', api.name)
  end

  class BadStatusError < StandardError; end

  class ServiceError < StandardError
    attr_reader :api_name
    def initialize(message, api_name)
      super(message)
      @api_name = api_name
    end
  end

  class TimeoutError < ServiceError; end
  class BadResponseError < ServiceError; end

end