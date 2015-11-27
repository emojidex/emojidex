require_relative '../data/collection'

module Emojidex
  module Service
    # a modified collection class for collections tied to the emojidex service
    class Collection < Emojidex::Data::Collection
      attr_reader :endpoint, :page
      def initialize(opts = {})
        @emoji = {}

        @page = opts[:page] || 1

        if (opts.key? :endpoint)
          @endpoint = opts.endpoint;
          @emoji = Transactor.get(endpoint, opts)
        end
        @emoji
      end
    end
  end
end
