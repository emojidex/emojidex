require_relative '../data/collection'
require_relative 'transactor'
require_relative '../defaults'

module Emojidex
  module Service
    # A modified collection class for collections tied to the emojidex service
    class Collection < Emojidex::Data::Collection
      attr_reader :endpoint, :page, :limit, :detailed, :auto_cache

      def initialize(opts = {})
        @opts = opts

        _init_emoji
        _init_user_info
        _init_endpoint

        @auto_cache = @opts[:auto_cache] || true
        @opts.delete(:auto_cache)

        auto_init = @opts[:auto_init] || true
        @opts.delete(:auto_init)

        more if auto_init
        @emoji
      end

      # Get the next page worth of emoji and add them to the collection
      def more()
        @page += 1

        opts = { page: @page, limit: @limit, detailed: @detailed }
        opts[:username] = @username unless @username.nil?
        opts[:auth_token] = @auth_token unless @auth_token.nil?
        opts.merge! @opts

        moji_page = Emojidex::Service::Transactor.get(@endpoint, opts)

        _process_moji_page(moji_page)
      end

      private

      def _init_emoji
        @emoji = {}
        return unless @opts.include? :emoji
        add_emoji(@opts[:emoji])
        @opts.delete(:emoji)
      end

      def _init_user_info
        @username = @opts[:username] || nil
        @opts.delete(:username)
        @auth_token = @opts[:auth_token] || nil
        @opts.delete(:auth_token)
      end

      def _init_endpoint
        @endpoint = @opts[:endpoint] || 'emoji'
        @opts.delete(:endpoint)
        @page = @opts[:page] || 0
        @opts.delete(:page)
        @limit = @opts[:limit] || Emojidex::Defaults.limit
        @opts.delete(:limit)
        @detailed = @opts[:detailed] || false
        @opts.delete(:detailed)
      end

      def _process_moji_page(moji_page)
        if moji_page.is_a? Hash
          unless moji_page.key? :emoji
            @page -= 1 # reset page beacuse we failed
            return {}
          end

          return add_emoji(moji_page[:emoji])
        end

        add_emoji(moji_page)
        cache! if @auto_cache
        moji_page
      end
    end
  end
end
