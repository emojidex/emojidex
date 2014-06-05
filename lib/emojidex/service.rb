require_relative 'collection'
require_relative 'client'

module Emojidex
  # listing and search of emoji from the online service/emojidex.com
  class Service < Collection
    attr_accessor :client
    def initialize(emoji_list = nil, client_opts = {})
      super emoji_list
      @client = Emojidex::Client.new client_opts
    end

    # sends an API search, adding results with add_emoji
    # returns a collection, and adds results to the @emoji array
    def search(criteria = {})
      # TODO *NOTE try and replicate regex search functionality by passing regex to server
    end

    # directly retrieves the emoji with the given code
    def find_by_code(code)
      # TODO
    end

    # emoji on the emojidex service make no language distinctions
    # find_by_code_ja is simply remapped to find_by_code
    def find_by_code_ja(code)
      find_by_code(code)
    end

    # TODO override or add caching functionality to retrieve sized png or svg from service
  end
end
