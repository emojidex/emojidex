require_relative '../defaults'
require_relative '../emojidex'

module Emojidex
  module Service
    class Search
      alias_method :search, :term

      # Searches by term with the options given. Options are:
      # tags: an array of tags to restrict the search to
      # categories: an arry of categories to restrict the serach to
      # detailed: set to true to enable detailed results (defaults to false)
      # limit: sets the number of items per page (default Emojidex::Defaults.limit)
      # Returns a service Collection.
      def term(code_term, options = {})
      end

      # Searches for a code starting with the given term.
      # Available options are the same as term.
      # Returns a service Collection.
      def starting(code_sw, options = {})
      end

      # Searches for a code ending with the given term.
      # Available options are the same as term.
      # Returns a service Collection.
      def ending(code_ew, options = {})
      end

      # Searches an array of tags for emoji associated with all those tags.
      # Available options are the same as term.
      # Returns a service Collection.
      def tags(tags, options = {})
      end

      def find(code)
      end

      # An expanded version of term with categories and tags as arguments.
      # Options are:
      # detailed: set to true to enable detailed results (defaults to false)
      # limit: sets the number of items per page (default Emojidex::Defaults.limit)
      # Returns a service Collection.
      def advanced(code_term, categories = [], tags = [], options = {})
      end
    end
  end
end
