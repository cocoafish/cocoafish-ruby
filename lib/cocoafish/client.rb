module Cocoafish

  class Client

    @@connection = nil
    @@debug = false

    class << self

      def set_credentials(token, secret)
        @@connection = Connection.new(token, secret)
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
        json_hash = @@connection.get endpoint, data
        parse_response(json_hash)
      end

      def delete(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash = @@connection.delete endpoint, data
        parse_response(json_hash)
      end

      def post(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash = @@connection.post endpoint, data
        parse_response(json_hash)
      end

      def put(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash = @@connection.put endpoint, data
        parse_response(json_hash)
      end
      
      def parse_response(json_hash)
      #  HashUtils.recursively_symbolize_keys(json_hash)
        ObjectifiedHash.new(json_hash)
      end
    end

  end

end
