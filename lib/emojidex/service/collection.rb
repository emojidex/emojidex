require_relative '../data/collection'
require_relative 'transactor'
require_relative '../defaults'

module Emojidex
  module Service
    # A modified collection class for collections tied to the emojidex service
    class Collection < Emojidex::Data::Collection
      attr_reader :endpoint, :page, :limit, :detailed, :auto_cache, :status

      def initialize(opts = {})
        @opts = opts

        @status = ''

        _init_emoji
        _init_user_info
        _init_endpoint
        _init_cache

        @auto_cache = @opts[:auto_cache] || true
        @opts.delete(:auto_cache)

        auto_init = @opts[:auto_init] || true
        @opts.delete(:auto_init)

        more if auto_init

        @emoji
      end

      # Get the next page worth of emoji and add them to the collection
      def more
        @page += 1

        opts = { page: @page, limit: @limit, detailed: @detailed }
        opts[:username] = @username unless @username.nil? || @username == ''
        opts[:auth_token] = @auth_token unless @auth_token.nil? || @auth_token == ''
        opts.merge! @opts

        begin
          moji_page = Emojidex::Service::Transactor.get(@endpoint, opts)
        rescue Error::Unauthorized => e
          @status = e.message
          return {}
        rescue Error::PaymentRequired => e
          @status = e.message
          return {}
        end

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

      def _init_cache
        if @opts.include? :cache_path
          setup_cache(@opts[:cache_path])
          @opts.delete :cache_path
        else
          setup_cache
        end
      end
    end
  end
end
