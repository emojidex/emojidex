
module Emojidex
  # Asset information for emoji
  module EmojiAssetInformation
    attr_accessor :assets, :base_path

    # returns asset path / returns nil if no asset is available
    def asset_path(format = :png, size = :px32)
      # TODO
    end

    # returns asset path, first obtaining and caching an asset if needed
    def asset_path!(format = :png, size = :px32)
      # TODO
    end
  end
end
