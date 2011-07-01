require 'uri'
require 'json'
require 'oauth'

require 'cocoafish/connection'
require 'cocoafish/endpoint'
require 'cocoafish/client'
require 'cocoafish/objectified_hash'

module Cocoafish
  REALM = "http://api.cocoafish.com"
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  class CocoafishError < StandardError; end
  class Unauthorized < CocoafishError; end
  class NotFound < CocoafishError; end
  class ServerError < CocoafishError; end
  class Unavailable < CocoafishError; end
  class DecodeError < CocoafishError; end
  class NoConnectionEstablished < CocoafishError; end
end
