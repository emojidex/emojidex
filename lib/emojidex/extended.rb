require_relative 'collection'

module Emojidex
  # listing and search of extended emoji from the emojidex set
  class Extended < Collection
    def initialize
      super
      if defined? Emojidex::Vectors
        load_local_collection Emojidex::Vectors.path + '/extended'
      else
        # TODO load from service
      end
    end
  end
end
