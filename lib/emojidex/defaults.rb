module Emojidex
  # Global defines for emojidex
  class Defaults
    @@selected_sizes = [:hdpi, :px32]
    @@selected_formats = [:png]

    def self.sizes
      { ldpi: 13, mdpi: 18, hdpi: 27, xhdpi: 36, xxhdpi: 54, xxxhdpi: 72,
        px8: 8, px16: 16, px32: 32, px64: 64, px128: 128, px256: 256, px512: 512,
        hanko: 90, seal: 320 }
    end

    def self.selected_sizes(sizes = nil)
      @@selected_sizes = sizes unless sizes.nil?
      @@selected_sizes
    end

    def self.formats
      [:svg, :png]
    end

    def self.selected_formats(formats = nil)
      @@selected_formats = formats unless formats.nil?
      @@selected_formats
    end

    def self.limit
      50
    end

    def self.lang
      'en'
    end

    def self.encapsulator
      ':'
    end

    def self.system_cache_path
      ENV['EMOJI_CACHE'] || "#{ENV['HOME']}/.emojidex/"
    end
  end
end
