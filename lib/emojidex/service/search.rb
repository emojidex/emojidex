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
        opts[:code_cont] = Emojidex.escape_code(code_cont)
        _do_search(opts)
      end

      def self.search(code_cont, opts = {})
        term(code_cont, opts)
      end

      # Searches for a code starting with the given term.
      # Available options are the same as term.
      # Returns a service Collection.
      def self.starting(code_sw, opts = {})
        opts[:code_sw] = Emojidex.escape_code(code_sw)
        _do_search(opts)
      end

      # Searches for a code ending with the given term.
      # Available options are the same as term.
      # Returns a service Collection.
      def self.ending(code_ew, opts = {})
        opts[:code_ew] = Emojidex.escape_code(code_ew)
        _do_search(opts)
      end

      # Searches an array of tags for emoji associated with all those tags.
      # Available options are the same as term.
      # Returns a service Collection.
      def self.tags(tags, opts = {})
        tags = [] << tags unless tags.class == Array
        opts[:tags] = tags
        _do_search(opts)
      end

      # An expanded version of term with categories and tags as arguments.
      # Options are:
      # detailed: set to true to enable detailed results (defaults to false)
      # limit: sets the number of items per page (default Emojidex::Defaults.limit)
      # Returns a service Collection.
      def self.advanced(code_cont, categories = [], tags = [], opts = {})
        opts[:code_cont] = Emojidex.escape_code(code_cont)
        tags = [] << tags unless tags.class == Array
        opts[:tags] = tags
        categories = [] << categories unless categories.class == Array
        opts[:categories] = categories
        _do_search(opts)
      end

      private

      def self._sanitize_opts(opts)
        opts[:tags].map!(&:to_s) if opts.include? :tags
        opts[:categories].map!(&:to_s) if opts.include? :categories
        opts
      end

      def self._do_search(opts)
        opts = _sanitize_opts(opts)
        opts[:endpoint] = 'search/emoji'
        begin
          col = Emojidex::Service::Collection.new(opts)
        rescue
          return Emojidex::Service::Collection.new
        end
        col
      end
    end
  end
end
