require_relative 'collection'

module Emojidex
  # listing and search of standard UTF emoji
  class UTF < Collection
    def initialize
      super 
      if defined? Emojidex::Vectors
        load_local_collection Emojidex::Vectors.path + '/utf'
      else
        # TODO load from service
      end
    end
  end
end
