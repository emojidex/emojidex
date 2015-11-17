module Emojidex
  # full client for emojidex
  class Client
    attr_reader :host

   # include Emojidex::API::Categories
   # include Emojidex::API::Emoji
   # include Emojidex::API::Search::Emoji

    def initialize(opts = {})
      @host = new Emojidex::ClientHost(opts)
    end

    def connection_options
      @connection_options ||= {
        url: @host,
        headers: {
          accept: 'application/json',
          user_agent: user_agent
        }
      }
    end

    def user_agent
      @user_agent ||= 'emojidexRuby'
    end

    def get(path, params = {})
      request(:get, path, params)
    end

    private

    def connection
      @connection ||= Faraday.new connection_options do |conn|
        conn.request :url_encoded
        conn.response :json
        # conn.response :logger
        conn.adapter Faraday.default_adapter
      end
    end

    def request(method, path, params = {})
      response = connection.send(method.to_sym, path, params)
      response.env
    rescue Faraday::Error::ClientError, JSON::ParserError
      raise Emojidex::Error
    end
  end
end
