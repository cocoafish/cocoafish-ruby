require 'uri'
require 'json'
require 'oauth'
require 'rest_client'

require 'cocoafish/connection'
require 'cocoafish/endpoint'
require 'cocoafish/client'
require 'cocoafish/objectified_hash'

module Cocoafish
  API_VERSION = "v1"
  CLIENT_VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  class CocoafishError < StandardError
    def initialize(e)
      @re = e
    end
    
    def to_s
      content = JSON.parse(@re.response)
      "#{@re.message} - #{content['meta']['message']}"
    end
    
    def http_code
      @re.http_code
    end
    
    def response
       @re.response
     end
  end
end
