require 'faraday'

module Emojidex
  class ClientHost
    attr_reader :url, :auth, :conn

    def initialize(opts = {})
      @url = opts[:url] || 'https://www.emojidex.com/api/v1/'
      @conn = Faraday::Connection.new(url: @url)
      @auth = opts[:auth] || nil
    end

    def get(path, opts = {})
      #faraday.g
    end

    def put(path, opts = {})
    end

    def post(path, opts = {})
    end

    def delete(path, opts = {})
    end
  end
end
