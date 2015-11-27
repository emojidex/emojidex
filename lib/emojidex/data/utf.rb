require_relative 'collection'

module Emojidex::Data
  # listing and search of standard UTF emoji
  class UTF < Collection
    def initialize
      super
      if defined? Emojidex::Vectors
        @vector_source_path = Emojidex::Vectors.path + '/utf/'
        load_local_collection @vector_source_path
      end
      if defined? Emojidex::Rasters
        @raster_source_path = Emojidex::Rasters.path + '/utf/'
        load_local_collection @raster_source_path
      end
      # TODO: load from service
      @emoji
    end
  end
end
