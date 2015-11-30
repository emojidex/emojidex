require 'faraday'
require 'json'

module Emojidex::Service
  class Transactor

    @@connection = nil

    @@settings = {
      api: {
        host: 'www.emojidex.com',
        prefix: '/api/v1/',
        protocol: 'https'
      },
      cdn: {
        host: 'cdn.emojidex.com',
        prefix: '/emoji/',
        protocol: 'http'
      },
      closed_net: false
    }

    def self.get(endpoint, params = {})
      response = self.connect.get(
        "#{self.api_url}#{endpoint}", params)

      begin
        data = JSON.parse(response.body)
      rescue JSON::ParserError
        return {}
      end
      data
    end

    def self.connect
      return @@connection if @@connection
      @@connection = Faraday.new do |conn|
        conn.request :url_encoded
        # conn.response :logger
        conn.adapter Faraday.default_adapter
      end
      @@connection
    end

    def self.api_url()
      "#{@@settings[:api][:protocol]}://#{@@settings[:api][:host]}#{@@settings[:api][:prefix]}"
    end

    private
    def user_agent
      @user_agent ||= 'emojidexRuby'
    end

    def _setup_connection
      @connection_options ||= {
        url: @host,
        headers: {
          accept: 'application/json',
          user_agent: user_agent
        }
      }
    end



    def request(method, path, params = {})
      response = connection.send(method.to_sym, path, params)
      response.env
    rescue Faraday::Error::ClientError, JSON::ParserError
      raise Emojidex::Error
    end
  end
end
