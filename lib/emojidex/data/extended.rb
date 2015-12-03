require_relative 'collection'
require_relative 'collection/static_collection'

module Emojidex::Data
  # listing and search of extended emoji from the emojidex set
  class Extended < Collection
    include Emojidex::Data::StaticCollection

    def initialize
      super
      @endpoint = 'extended_emoji'
      loaded = false
      if defined? Emojidex::Vectors
        @vector_source_path = Emojidex::Vectors.path + '/extended/'
        load_local_collection @vector_source_path
        loaded = true
      end
      if defined? Emojidex::Rasters
        @raster_source_path = Emojidex::Rasters.path + '/extended/'
        load_local_collection @raster_source_path
        loaded = true
      end
      load_from_server unless loaded
      @emoji
    end
  end
end
