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
        response = connect.get(
          "#{api_url}#{endpoint}", params)

        _status_raiser(response)
        _datafy_json(response.body)
      end

      def self.post(endpoint, params = {})
        response = connect.post(
          "#{api_url}#{endpoint}", params)

        _status_raiser(response)
        _datafy_json(response.body)
      end

      def self.delete(endpoint, params = {})
        response = connect.delete(
          "#{api_url}#{endpoint}", params)

        _status_raiser(response)
        _datafy_json(response.body)
      end

      def self.download(file_subpath)
        connect.get(URI.escape("#{cdn_url}#{file_subpath}"))
      end

      def self.connect
        return @@connection if @@connection
        @@connection = Faraday.new do |conn|
          conn.request :url_encoded
          # conn.response :logger
          conn.adapter Faraday.default_adapter
        end
        _kludge_windows if Gem.win_platform?
        @@connection
      end

      def self.api_url()
        "#{@@settings[:api][:protocol]}://#{@@settings[:api][:host]}#{@@settings[:api][:prefix]}"
      end

      def self.cdn_url()
        "#{@@settings[:cdn][:protocol]}://#{@@settings[:cdn][:host]}#{@@settings[:cdn][:prefix]}"
      end

      private

      def self._status_raiser(response)
        case response.status
        when 200..299
          return # don't raise
        when 401
          fail Error::Unauthorized, _extract_status_line(response)
        when 422
          fail Error::UnprocessableEntity _extract_status_line(response)
        end
      end

      def self._extract_status_line(response)
        data = _datafy_json(response.body)
        status_line = (data.key?(:status) ? data[:status] : '')
        status_line
      end

      def self._datafy_json(body)
        begin
          data = JSON.parse(body, symbolize_names: true)
        rescue JSON::ParserError
          raise Error::InvalidJSON, 'could not parse JSON'
        end
        data
      end

      def _kludge_windows
        cert_loc = "#{__dir__}/../../cacert.pem"
        unless File.exist? cert_loc 
          response = @@connection.get("http://curl.haxx.se/ca/cacert.pem")
          File.open(cert_loc, 'wb') { |fp| fp.write(response.body) }
        end
        ENV['SSL_CERT_FILE'] = cert_loc
      end
    end
  end
end
