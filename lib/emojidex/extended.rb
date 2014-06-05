require_relative 'collection'

module Emojidex
  # listing and search of extended emoji from the emojidex set
  class Extended < Collection
    def initialize
      super
      load_local_collection File.expand_path('../../../emoji/extended', __FILE__)
    end
  end
end
