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

      def path(format, size = nil)
        fp = path?(format, size)
        cache(format, size) unless (fp != nil && File.exist?(fp))
        fp
      end

      # returns asset path
      def path?(format, size = nil)
        case format
        when :svg
          return @paths[format] if File.exist?(@paths[format])
        when :png
          return nil if size.nil?
          return @paths[format][size] if File.exist?(@paths[format][size])
        end
        nil
      end

      def cache(format, size = nil)
        case format
        when :png
          _cache_png(size) unless size.nil?
        when :svg
          _cache_svg
        end
      end

      private

      def _cache_svg
        @paths[:svg] = Dir.pwd unless (@paths.include? :svg && @paths[:svg] != nil)
        response = Emojidex::Service::Transactor.download("#{code}.svg")
        File.open(@paths[:svg], 'wb') { |fp| 
          fp.write(response.body) }
      end

      def _cache_png(size)
        @paths[:png][size] = "#{Dir.pwd}/#{size}/#{code}.png" unless ((@paths.include? :png) && 
                                  (@paths[:png].include? size) && (@paths[:png][size] != nil))
        response = Emojidex::Service::Transactor.download("#{size}/#{code}.png")
        File.open(path?(:png, size), 'wb') { |fp| 
          fp.write(response.body) }
      end
    end
  end
end
