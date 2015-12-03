require_relative 'collection'
require_relative '../service/transactor'
require_relative '../env_helper'

module Emojidex::Data
  # listing and search of standard UTF emoji
  class UTF < Collection
    def initialize
      super
      loaded = false
      if defined? Emojidex::Vectors
        @vector_source_path = Emojidex::Vectors.path + '/utf/'
        load_local_collection @vector_source_path
        loaded = true
      end
      if defined? Emojidex::Rasters
        @raster_source_path = Emojidex::Rasters.path + '/utf/'
        load_local_collection @raster_source_path
        loaded = true
      end
      load_from_server unless loaded
      @emoji
    end

    def load_from_server(detailed = true, locale = '??')
      locale = Emojidex::EnvHelper.lang? if locale == '??'
      begin
        res = Emojidex::Service::Transactor.get('utf_emoji', {detailed: detailed, locale: locale})
      rescue
        return false
      end
      add_emoji(res)
      return true
    end
  end
end
