module Emojidex
  # Obtains and parses local environment variables
  module EnvHelper

    def self.lang?
      lang = ENV['LANG'].match('^..')
      lang = 'en' unless lang.to_s == 'ja'
      lang
    end
  end
end
