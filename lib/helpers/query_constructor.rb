require 'net/http'
require 'openssl'
require 'json'

require 'config/keys.yml'
@content_type = 'application/x-www-form-urlencoded'
@host = 'https://slack.com/api/'
@token =

class QueryConstructor
  def initialize(params, method)
    @uri = URI.parse("#{@host}#{method}")
    @uri.query = URI.encode_www_form(params)
  end

  def call
    Net::HTTP.get_response(@uri)
  end
end