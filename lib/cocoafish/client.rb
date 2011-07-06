module Cocoafish

  class Client

    @@connection = nil
    @@debug = false
    @@realm = "http://api.cocoafish.com"

    class << self

      def set_credentials(token, secret, realm = nil)
        @@realm = realm || @@realm
        @@connection = Connection.new(token, secret, @@realm)
        @@connection.debug = @@debug
      end

      def debug=(debug_flag)
        @@debug = debug_flag
        @@connection.debug = @@debug  if @@connection
      end

      def debug
        @@debug
      end
      
      def get(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.get Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end
      
      def get_json(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.get Cocoafish::Endpoint.url(@@realm, endpoint), data
        json
      end

      def delete(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.delete Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end
      
      def delete_json(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.delete Cocoafish::Endpoint.url(@@realm, endpoint), data
        json
      end

      def post(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.post Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end
      
      def post_json(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.post Cocoafish::Endpoint.url(@@realm, endpoint), data
        json
      end

      def put(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.put Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end
      
      def put_json(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash, json = @@connection.put Cocoafish::Endpoint.url(@@realm, endpoint), data
        json
      end
      
      def parse_response(json_hash)
        ObjectifiedHash.new(json_hash)
      end
    end

  end

end
