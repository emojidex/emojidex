require_relative '../../defaults'

module Emojidex
  module Data
    # Asset information for emoji
    module EmojiAssetInformation
      attr_accessor :checksums, :paths

      def init_asset_info(details)
        blank_checksums
        fill_checksums(details[:checksums]) if details.include? :checksums
      end

      # returns asset checksum
      def checksum?(format, size = nil)
        puts @checksums
        return @checksums[format][size] unless size.nil?
        @checksums[format]
      end

      def blank_checksums
        @checksums = {}
        @checksums[:svg] = nil
        @checksums[:png] = {}
        Emojidex::Defaults.sizes.keys.each do |size|
          @checksums[:png][size] = nil
        end
      end

      def fill_checksums(checksums)
        @checksums[:svg] = checksums[:svg] if checksums.include? :svg
        return unless checksums.include? :png
        Emojidex::Defaults.sizes.keys.each do |size|
          @checksums[:png][size] = checksums[:png][size] if checksums[:png].include? size
        end
      end

      # returns asset path
      def path?(format, size = nil)
        return @paths[format][size] unless size.nil?
        @paths[format]
      end
    end
  end
end
