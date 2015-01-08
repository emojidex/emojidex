require 'faraday'
require 'faraday_middleware'

require 'emojidex/api/categories'
require 'emojidex/api/emoji'
require 'emojidex/api/search/emoji'

module Emojidex
  # get the data from emojidex.com
  class Client
    attr_accessor :api_key, :api_username
    attr_reader :host

    include Emojidex::API::Categories
    include Emojidex::API::Emoji
    include Emojidex::API::Search::Emoji

    def initialize(opts = {})
      @api_key = opts[:api_key]
      @api_username = opts[:api_username]
      @host = opts[:host] || 'https://www.emojidex.com'
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
      @user_agent ||= 'emojidexRubyClient'
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
