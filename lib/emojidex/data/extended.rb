require_relative 'collection'
require_relative 'collection/static_collection'

module Emojidex
  module Data
    # listing and search of extended emoji from the emojidex set
    class Extended < Collection
      include Emojidex::Data::StaticCollection

      def initialize(opts = {})
        super(opts)
        @endpoint = 'extended_emoji'
        load_from_server unless check_and_load_static('extended')
        @emoji
      end
    end
  end
end
