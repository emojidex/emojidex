require_relative '../../service/transactor'
require_relative '../../env_helper'

module Emojidex
  module Data
    # mixin module to enable static collections
    module StaticCollection
      def load_from_server(detailed = true, locale = '??')
        locale = @locale || Emojidex::EnvHelper.lang? if locale == '??'
        begin
          res = Emojidex::Service::Transactor.get(@endpoint, detailed: detailed, locale: locale)
        rescue
          false
        end
        add_emoji(res)
        true
      end

      def check_and_load_static(collection)
        loaded = false
        if defined? Emojidex::Vectors
          @vector_source_path = Emojidex::Vectors.path + "/#{collection}/"
          load_local_collection @vector_source_path
          loaded = true
        end
        if defined? Emojidex::Rasters
          @raster_source_path = Emojidex::Rasters.path + "/#{collection}/"
          load_local_collection @raster_source_path
          loaded = true
        end
        loaded
      end
    end
  end
end
