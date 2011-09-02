module Cocoafish

  class Client

    @@connection = nil
    @@debug = false
    @@realm = "http://api.cocoafish.com"

    class << self

      def set_credentials(token, secret, options = {})
        @@realm = options[:hostname] || @@realm
        @@connection = Connection.new(token, secret, options)
        @@connection.debug = @@debug
      end
      
      def set_session_id(session_id = nil)
        @@connection.session_id = session_id
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
        CocoafishObject.new(json_hash)
      end

      def get_paginated_array(response)
        
        # return nil for empty json
        if response.json == nil
          return nil
        end
        
        # make sure we have only 1 top-level object in the response (users, places, etc.)
        if response.response.instance_variables.count != 1
          return nil
        end
        
        # get the response array
        orig_array = response.response.instance_variable_get(response.response.instance_variables.first)

        # create the paginated object
        if response.meta.page && orig_array     
          WillPaginate::Collection.create(response.meta.page, response.meta.per_page, response.meta.total_results) do |pager|
            pager.replace(orig_array)
          end
        end
      end
    end
  end
end
