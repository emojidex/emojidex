require_relative '../data/collection'
require_relative 'transactor'
require_relative '../defaults'

module Emojidex
  module Service
    # A modified collection class for collections tied to the emojidex service
    class Collection < Emojidex::Data::Collection
      attr_reader :endpoint, :page, :limit, :detailed

      def initialize(opts = {})
        @emoji = opts[:emoji] || {}
        opts.delete(:emoji)

        @username = opts[:username] || nil
        opts.delete(:username)
        @auth_token = opts[:auth_token] || nil
        opts.delete(:auth_token)

        @endpoint = opts[:endpoint] || 'emoji'
        opts.delete(:endpoint)
        @page = opts[:page] || 0
        opts.delete(:page)
        @limit = opts[:limit] || Emojidex::Defaults.limit
        opts.delete(:limit)
        @detailed = opts[:detailed] || false
        opts.delete(:detailed)

        @opts = opts

        more
        @emoji
      end

      # Get the next page worth of emoji and add them to the collection
      def more()
        @page += 1

        opts = { page: @page, limit: @limit, detailed: @detailed }
        opts[:username] = @username unless @username.nil?
        opts[:auth_token] = @auth_token unless @auth_token.nil?
        opts.merge! @opts

        page_moji = Emojidex::Service::Transactor.get(@endpoint, opts)

        if page_moji.is_a? Hash
          unless page_moji.key? :emoji
            @page -= 1 # reset page beacuse we failed
            return {}
          end

          add_emoji(page_moji[:emoji])
          return page_moji[:emoji]
        end
        add_emoji(page_moji)
        page_moji
      end
    end
  end
end
