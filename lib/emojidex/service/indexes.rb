require_relative 'transactor'
require_relative 'collection'
require_relative '../defaults'

module Emojidex
  module Service
    # emoji indexes
    class Indexes
      # Obtain a service Collection of emoji indexed by score.
      # This is the default index.
      def self.emoji(detailed = false, limit = Emojidex::Defaults.limit, page = 0)
        Emojidex::Service::Collection.new(endpoint: 'emoji', detailed: detailed,
                                          limit: limit, page: page)
      end

      # Obtain a service Collection of emoji indexed by date of creation (or in some cases update).
      def self.newest(detailed = false, limit = Emojidex::Defaults.limit, page = 0,
                      username = nil, auth_token = nil)
        Emojidex::Service::Collection.new(endpoint: 'newest', detailed: detailed,
                                          limit: limit, page: page,
                                          username: username, auth_token: auth_token)
      end

      # Obtain a service Collection of emoji indexed by popularity
      # [how many times they have been favorited].
      def self.popular(detailed = false, limit = Emojidex::Defaults.limit, page = 0,
                       username = nil, auth_token = nil)
        Emojidex::Service::Collection.new(endpoint: 'popular', detailed: detailed,
                                          limit: limit, page: page,
                                          username: username, auth_token: auth_token)
      end

      # Obtains a hash with three different types of chracter [moji] code indexes:
      # moji_string: a string that can be used for things like regex matches.
      #   Contains conglomorate codes ahead of single chracter codes.
      # moji_array: an array of emoji characters.
      #   Contains conglomorate codes ahead of single chracter codes.
      # moji_index: a hash map with the keys being emoji strings and the values being
      #   the emoji short codes in the locale [language] specified (defaults to english).
      def self.moji_codes(locale = Emojidex::Defaults.lang)
        begin
          res = Emojidex::Service::Transactor.get('moji_codes', locale: locale)
        rescue
          return { moji_string: '', moji_array: [], moji_index: {} }
        end
        res[:moji_index] = Hash[res[:moji_index].map { |k, v| [k.to_s, v] }]
        res
      end

      def self.user_emoji(username, detailed = false, limit = Emojidex::Defaults.limit, page = 0)
        Emojidex::Service::Collection.new(endpoint: "users/#{username}/emoji", detailed: detailed,
                                          limit: limit, page: page)
      end
    end
  end
end
