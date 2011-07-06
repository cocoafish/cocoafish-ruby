module Cocoafish
  class Connection

    attr_accessor :debug

    def initialize(token, secret, realm)
      @key = token
      @secret = secret
      @cookies = Hash.new
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

      headers = { 'User-Agent' => "Cocoafish Ruby Client v#{CLIENT_VERSION}", :cookies => @cookies }

      oauth_options = {
        :consumer_key => @key,
        :consumer_secret => @secret,
        :token => "",
        :token_secret => "",
        :nonce => rand(10 ** 30).to_s.rjust(30,'0'),
        :timestamp => Time.now.to_i
      }
      
      case method
        when :get, :delete
          
          oauth_header = SimpleOAuth::Header.new(method, endpoint, data, oauth_options)
          options = headers.merge(:params => data, :authorization => oauth_header)
          begin
            response = RestClient.send(method, endpoint, options)            
          rescue RestClient::Exception => e
            raise CocoafishError.new(e), nil, caller[5..-1]
          end

        when :post, :put
          
          data.each do |key,value|
            if key.to_s == "photo" || key.to_s =~ /photos\[\d+\]/
              data[key] = File.new(value, 'rb')
            end
          end
          data.merge!(:multipart => true)

          oauth_header = SimpleOAuth::Header.new(method, endpoint, nil, oauth_options)
          options = headers.merge(:authorization => oauth_header)
          
          begin
            response = RestClient.send(method, endpoint, data, options)
          rescue RestClient::Exception => e
            raise CocoafishError.new(e), nil, caller[3..-1]
          end
      end
        
      @cookies.merge!(response.cookies)

      if response.body.empty?
        content = nil
      else
        begin
          content = JSON.parse(response.body)
        rescue JSON::ParserError
          raise DecodeError, "content: <#{response.body}>"
        end
        # add json data
        content[:json] = response.body
      end
      
      return content
    end
  end
end
