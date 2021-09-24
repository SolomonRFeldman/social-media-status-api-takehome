
class SocialMediaApiService
  class << self
    SOCIAL_MEDIA_APIS = [
      { name: :twitter, uri: 'https://takehome.io/twitter'},
      { name: :facebook, uri: 'https://takehome.io/facebook'},
      { name: :instagram, uri: 'https://takehome.io/instagram'}
    ]

    def index
      response = {}
      SOCIAL_MEDIA_APIS.each do |api|
        response[api[:name]] = fetch_api(api)
      end
      response
    end

    private

    def fetch_api(api)
      resp = Net::HTTP.get_response(URI(api[:uri]))
      resp.code == "200" ? JSON.parse(resp.body) : raise_bad_response(api[:name])
    rescue JSON::ParserError => error
      raise_bad_response(api[:name])
    end

    def raise_bad_response(api_name)
      raise(BadResponseError.new('api returned an invalid response', api_name))
    end
  end

  class BadResponseError < StandardError
    attr_reader :api_name
    def initialize(message, api_name)
      super(message)
      @api_name = api_name
    end
  end
end