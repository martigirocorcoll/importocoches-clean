class ApiCaller
  require 'base64'
  require "nokogiri"
  require 'rest-client'

  def initialize(endpoint)
    @endpoint = endpoint
  end

  def call
    response = RestClient.get(
      @endpoint,
      {
        Accept: 'application/xml',
        'Accept-Language': 'es',
        Authorization: "Basic #{app_auth}"
      }
    )
    Nokogiri::XML(response)
  end

  private

  def app_auth
    Base64.encode64(ENV['MOBILE_API_KEY'])
  end
end
