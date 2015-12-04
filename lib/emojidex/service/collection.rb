require_relative '../data/collection'
require_relative 'transactor'

module Emojidex
  module Service
    # A modified collection class for collections tied to the emojidex service
    class Collection < Emojidex::Data::Collection
      attr_reader :endpoint, :page, :limit, :detailed
      @username
      @auth_token

      def initialize(opts = {})
        @emoji = opts[:emoji] || {}

        @username = opts[:username] || nil
        @auth_token = opts[:auth_token] || nil

        @endpoint = opts[:endpoint] || 'emoji'
        @page = opts[:page] || 0
        @limit = opts[:limit] || 50
        @detailed = opts[:detailed] || false

        more
        @emoji
      end

      def more()
        @page += 1

        opts = {page: @page, limit: @limit, detailed: @detailed}
        opts[:username] = @username unless @username.nil?
        opts[:auth_token] = @auth_token unless @auth_token.nil?

        page_moji = Emojidex::Service::Transactor.get(@endpoint, opts)

        if page_moji.is_a? Hash
          if !page_moji.key? :emoji
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
