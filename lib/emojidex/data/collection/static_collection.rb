require_relative '../../service/transactor'
require_relative '../../env_helper'

module Emojidex::Data
  # mixin module to enable static collections
  module StaticCollection
    def load_from_server(detailed = true, locale = '??')
      locale = Emojidex::EnvHelper.lang? if locale == '??'
      begin
        res = Emojidex::Service::Transactor.get(@endpoint, {detailed: detailed, locale: locale})
      rescue
        return false
      end
      add_emoji(res)
      return true
    end
  end
end
