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
        json_hash = @@connection.get Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end

      def delete(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash = @@connection.delete Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end

      def post(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash = @@connection.post Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end

      def put(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        json_hash = @@connection.put Cocoafish::Endpoint.url(@@realm, endpoint), data
        parse_response(json_hash)
      end
      
      def parse_response(json_hash)
        ObjectifiedHash.new(json_hash)
      end

      def get_paginated_array(response)
        if response.json == nil
          return nil
        end
        content = JSON.parse(response.json)
        if content["response"].keys.count != 1
          return nil
        end

        arrayname = content["response"].keys.first
        orig_array = response.response.send arrayname
        if response.meta.page && orig_array     
          array =  WillPaginate::Collection.create(response.meta.page, response.meta.per_page, response.meta.total_results) do |pager|
            pager.replace(orig_array)
          end
        end
        array
      end

      
  end

end
