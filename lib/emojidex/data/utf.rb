require_relative 'collection'
require_relative 'collection/static_collection'

module Emojidex
  module Data
    # listing and search of standard UTF emoji
    class UTF < Collection
      include Emojidex::Data::StaticCollection

      def initialize(opts = {})
        super(opts)
        @endpoint = 'utf_emoji'
        @locale = opts[:locale] || Emojidex::Defaults.locale
        load_from_server((opts[:detailed] || true), @locale) unless check_and_load_static('utf')
        @emoji
      end
    end
  end
end
