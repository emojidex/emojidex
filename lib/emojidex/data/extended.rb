require_relative 'collection'

module Emojidex::Data
  # listing and search of extended emoji from the emojidex set
  class Extended < Collection
    def initialize
      super
      if defined? Emojidex::Vectors
        @vector_source_path = Emojidex::Vectors.path + '/extended/'
        load_local_collection @vector_source_path
      end
      if defined? Emojidex::Rasters
        @raster_source_path = Emojidex::Rasters.path + '/extended/'
        load_local_collection @raster_source_path
      end
      # TODO: load from service
    end
  end
end
