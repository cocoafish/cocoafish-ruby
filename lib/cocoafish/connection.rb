module Cocoafish
  class Connection

    attr_accessor :session_id, :debug

    def initialize(token, secret, options = {})
      @key = token
      @secret = secret
      @cookies = Hash.new
      @options = options
      @user_agent = @options.delete(:user_agent)
      @user_agent = "Cocoafish Ruby Client v#{CLIENT_VERSION}" if !@user_agent
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
      if data
        if !data.is_a?(Hash)
          raise "data must be a hash of parameters"
        end
        data.each_pair do |k,v|
          if v.is_a?(Hash) || v.is_a?(Array)
            data[k] = v.to_json
          end
        end
      end

      # set the cookies to send with the header
      if !@options.has_key?(:manage_cookies) || @options[:manage_cookies] != false
        @header_cookies = @cookies
      else
        @header_cookies = {}
      end

      # set the session id
      if @session_id
        @header_cookies[:_session_id] = @session_id
      end

      headers = { 'User-Agent' => @user_agent, :cookies => @header_cookies }

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
          data.merge!(:multipart => true)

          oauth_header = SimpleOAuth::Header.new(method, endpoint, nil, oauth_options)
          options = headers.merge(:authorization => oauth_header)

          begin
            response = RestClient.send(method, endpoint, data, options)
          rescue RestClient::Exception => e
            raise CocoafishError.new(e), nil, caller[3..-1]
          end
      end

      # grab the cookies from the response
      @cookies.merge!(response.cookies)

      if response.body.empty?
        content = nil
      else
        begin
          content = JSON.parse(response.body)
        rescue JSON::ParserError
          # Binary data
          return response.body
        end
        # add json data
        content[:json] = response.body
      end

      return content
    end

  end
end
