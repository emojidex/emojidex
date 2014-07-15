
require_relative 'defaults.rb'

module Emojidex
  # Check collection.
  class CollectionChecker
    attr_reader :collection_only_emojis, :cache_only_emojis

    def initialize(collections, cache_dir, sizes = Defaults.sizes, formats = Defaults.formats)
    end
  end # class CollectionChecker
end # module Emojidex
