require 'uri'
require 'json'
require 'rest_client'
require 'simple_oauth'
require 'hashie'

require 'cocoafish/connection'
require 'cocoafish/endpoint'
require 'cocoafish/client'
require 'cocoafish/cocoafish_object'
require 'cocoafish/objectified_hash'

module Cocoafish
  API_VERSION = "v1"
  CLIENT_VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  class CocoafishError < StandardError
    def initialize(response)
      @response = response
    end

    def to_s
      content = JSON.parse(@response.response)
      "#{@response.message} - #{content['meta']['message']}"
    end

    def http_code
      @response.http_code
    end

    def response
       @response.response
     end
  end
end
