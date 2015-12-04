require 'faraday'
require 'json'
require_relative 'error'

module Emojidex
  module Service
    # API transaction utility
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

        self._status_raiser(response)
        self._datafy_json(response.body)
      end

      def self.post(endpoint, params = {})
        response = self.connect.post(
          "#{self.api_url}#{endpoint}", params)

        self._status_raiser(response)
        self._datafy_json(response.body)
      end

      def self.delete(endpoint, params = {})
        response = self.connect.delete(
          "#{self.api_url}#{endpoint}", params)

        self._status_raiser(response)
        self._datafy_json(response.body)
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

      def self._status_raiser(response)
        case response.status
        when 200..299
          return # don't raise
        when 401
          raise Error::Unauthorized.new(self._extract_status_line(response))
        when 422
          raise Error::UnprocessableEntity.new(self._extract_status_line(response))
        end
      end

      def self._extract_status_line(response)
          data = self._datafy_json(response.body)
          status_line = (data.key?(:status) ? data[:status] : '')
          status_line
      end

      def self._datafy_json(body)
        begin
          data = JSON.parse(body, symbolize_names: true)
        rescue JSON::ParserError
          raise Error::InvalidJSON.new('could not parse JSON')
        end
        data
      end
    end
  end
end
