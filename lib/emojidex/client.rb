require_relative 'defaults'
require_relative 'service/user'
require_relative 'data/collection'

module Emojidex
  # A consolidated client which handles a user and their collection
  class Client
    @@client_cache_path = nil
    @@user_instance = nil
    @@collection_instance = nil

    def self.USER
      return @@user_instance unless @@user_instance.nil?
      @@user_instance = Emojidex::Service::User.new
      @@user_instance.load(@cache_path)
      @@user_instance
    end

    def user
      Emojidex::Client.USER
    end

    def self.COLLECTION
      return @@collection_instance unless @@collection_instance.nil?
      @@collection_instance = Emojidex::Data::Collection.new
      @@collection_instance.load_cache
      @@collection_instance
    end

    def collection
      Emojidex::Client.COLLECTION
    end

    def self.CACHE_PATH
      return @@client_cache_path unless @@client_cache_path.nil?
      @@client_cache_path = Emojidex::Defaults.system_cache_path
      @@client_cache_path
    end

    def cache_path
      Emojidex::Client.CACHE_PATH
    end

    def initialize(opts = {})
      if opts.include? :cache_path
        @@client_cache_path = opts[:cache_path]
        @@user_instance = @@collection_instance = nil
      end
      user # prime user
      collection # prime collection
    end
  end
end
