module Cocoafish
  class Connection

    attr_accessor :debug

    def initialize(token, secret)
      consumer = OAuth::Consumer.new(token, secret, :site => REALM)
      @access_token = OAuth::AccessToken.new(consumer)
      debug = false
    end

    def get(endpoint, data=nil)
      request :get, endpoint, data
    end

    def delete(endpoint, data=nil)
      request :delete, endpoint, data
    end

    def post(endpoint, data=nil)
      request :post, endpoint, data
    end

    def put(endpoint, data=nil)
      request :put, endpoint, data
    end

    private

      def request(method, endpoint, data)
        headers = {'User-Agent' => "Cocoafish Ruby Client v#{VERSION}"}
      #  puts "@cookies is #{@cookies}"
        headers['Cookie'] = @cookies unless @cookies.blank?

        if [:get, :delete].include?(method) && !data.nil?
          endpoint = endpoint + '?' + build_query(data)
        end

        if debug
          puts "request: #{method.to_s.upcase} #{endpoint}"
          puts "headers:" 
          request.header.each do |key, value|
            puts "#{key}=#{value}"
          end
          if [:post, :put].include?(method) && !data.nil?
            puts "data:"
            puts data.to_json
          end
        end

        case method
          when :get, :delete
            response = @access_token.request(method, endpoint, headers)
          when :put
            # bug with ruby oauth gem, have to put params in the url for now
            response = @access_token.request(method, endpoint, data, headers)
          when :post
            response = @access_token.request(method, endpoint, data, headers)
        end

        response.header.each do |key, value|
          if key == "set-cookie"
            @cookies = value
           end
        end
        
        if debug
          puts "\nresponse: #{response.code}"
          puts "headers:"
          response.header.each do |key, value|
            puts "#{key}=#{value}"
          end
          puts "body:"
          puts response.body
        end

        raise_errors(response)

        if response.body.empty?
          content = nil
        else
          begin
            content = JSON.parse(response.body)
          rescue JSON::ParserError
            raise DecodeError, "content: <#{response.body}>"
          end
        end

        content
      end

      def build_query(data)
        data.map do |key, value|
          [key.to_s, URI.escape(value.to_s)].join('=')
        end.join('&')
      end

      def raise_errors(response)
        response_description = "(#{response.code}): #{response.message}"
        response_description += " - #{response.body}"  unless response.body.empty?

        case response.code.to_i
          when 401
            raise Unauthorized
          when 404
            raise NotFound
          when 500
            raise ServerError, "Cocoafish had an internal error. Please let them know. #{response_description}"
          when 502..503
            raise Unavailable, response_description
          else
            unless response.is_a? Net::HTTPSuccess
              raise CocoafishError, response_description
            end
        end
      end

  end
end
