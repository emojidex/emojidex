require_relative 'collection'

module Emojidex
  # listing and search of standard UTF emoji
  class UTF < Collection
    def initialize
      super
      load_local_collection File.expand_path('../../../emoji/utf', __FILE__)
    end
  end
end
