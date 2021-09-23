
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
        response[api[:name]] = JSON.parse(Net::HTTP.get(URI(api[:uri])))
      end
      response
    end
  end
end