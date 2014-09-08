
module Emojidex
  # Asset information for emoji
  module EmojiAssetInformation
    attr_accessor :checksums, :paths

    # returns asset checksum
    def checksum?(format, variant = nil)
      puts @checksums
      return @checksums[format][variant] unless variant.nil?
      @checksums[format]
    end

    # returns asset path
    def path?(format, variant = nil)
      return @paths[format][variant] unless variant.nil?
      @paths[format]
    end
  end
end
