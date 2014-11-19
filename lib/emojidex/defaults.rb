module Emojidex
  # Global defines for emojidex
  class Defaults
    def self.sizes
      { ldpi: 9, mdpi: 18, hdpi: 27, xhdpi: 36, px8: 8,
        px16: 16, px32: 32, px64: 64, px128: 128, px256: 256, px512: 512,
        hanko: 90, seal: 320 }
    end

    def self.formats
      [:svg, :png]
    end
  end
end
