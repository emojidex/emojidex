require_relative '../defaults'
require_relative 'collection'
require_relative '../../emojidex'

module Emojidex
  module Service
    class Search

      # Searches by term with the options given. Options are:
      # tags: an array of tags to restrict the search to
      # categories: an arry of categories to restrict the serach to
      # detailed: set to true to enable detailed results (defaults to false)
      # limit: sets the number of items per page (default Emojidex::Defaults.limit)
      # Returns a service Collection.
      def self.term(code_cont, opts = {})
        opts[:endpoint] = 'search/emoji'
        opts[:code_cont] = Emojidex.escape_code(code_cont)
        begin
          col = Emojidex::Service::Collection.new(opts)
        rescue
          return Emojidex::Service::Collection.new
        end
        col
      end
      def self.search(code_cont, opts = {})
        self.term(code_cont, opts)
      end

      # Searches for a code starting with the given term.
      # Available options are the same as term.
      # Returns a service Collection.
      def self.starting(code_sw, opts = {})
        opts[:endpoint] = 'search/emoji'
        opts[:code_sw] = Emojidex.escape_code(code_sw)
        begin
          col = Emojidex::Service::Collection.new('search/emoji', opts)
        rescue
          return Emojidex::Service::Collection.new
        end
        col
      end

      # Searches for a code ending with the given term.
      # Available options are the same as term.
      # Returns a service Collection.
      def self.ending(code_ew, opts = {})
      end

      # Searches an array of tags for emoji associated with all those tags.
      # Available options are the same as term.
      # Returns a service Collection.
      def self.tags(tags, opts = {})
      end

      def self.find(code)
      end

      # An expanded version of term with categories and tags as arguments.
      # Options are:
      # detailed: set to true to enable detailed results (defaults to false)
      # limit: sets the number of items per page (default Emojidex::Defaults.limit)
      # Returns a service Collection.
      def self.advanced(code_term, categories = [], tags = [], opts = {})
      end
    end
  end
end
