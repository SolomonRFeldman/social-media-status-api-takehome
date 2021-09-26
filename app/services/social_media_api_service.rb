
class SocialMediaApiService
  class << self
    delegate :index, to: :new
  end

  @@social_media_apis = [
    OpenStruct.new(name: :twitter, uri: 'https://takehome.io/twitter'),
    OpenStruct.new(name: :facebook, uri: 'https://takehome.io/facebook'),
    OpenStruct.new(name: :instagram, uri: 'https://takehome.io/instagram')
  ]

  delegate :social_media_apis, to: :class

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
    resp = Net::HTTP.get_response(URI(api.uri))
    raise BadStatusError.new unless resp.code == "200"

    JSON.parse(resp.body)
  rescue JSON::ParserError, BadStatusError => error
    raise BadResponseError.new('service returned an invalid response', api.name)
  end

  class BadStatusError < StandardError; end

  class BadResponseError < StandardError
    attr_reader :api_name
    def initialize(message, api_name)
      super(message)
      @api_name = api_name
    end
  end
end