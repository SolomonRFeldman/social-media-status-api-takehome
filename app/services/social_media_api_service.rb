
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
        api_resp = Net::HTTP.get_response(URI(api[:uri]))
        response[api[:name]] = parse_response(api_resp)
      end
      response
    end

    private

    def parse_response(resp)
      resp.code == "200" ? JSON.parse(resp.body) : raise(BadResponseError.new)
    end
  end

  class BadResponseError < StandardError; end
end