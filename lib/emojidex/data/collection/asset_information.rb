require 'digest/md5'
require_relative '../../defaults'

module Emojidex
  module Data
    # Asset Information for Collections
    module CollectionAssetInformation
      def generate_checksums(formats = Emojidex::Defaults.formats,
                             sizes = Emojidex::Defaults.sizes)
        @emoji.values.each do |moji|
          moji.checksums = get_checksums(moji, formats, sizes)
        end
      end

      def get_checksums(moji, formats = Emojidex::Defaults.formats,
                        sizes = Emojidex::Defaults.sizes)
        sums = {}
        sums[:svg] = _checksum_for_file("#{@vector_source_path}/#{moji.code}.svg") if formats.include? :svg
        if formats.include? :png
          sums[:png] = {}
          sizes.keys.each do |size|
            sums[:png][size] = _checksum_for_file("#{@raster_source_path}/#{size}/#{moji.code}.png")
          end
        end
        sums
      end

      def generate_paths(formats = Emojidex::Defaults.formats, sizes = Emojidex::Defaults.sizes)
        @emoji.values.each do |moji|
          moji.paths = get_paths(moji, formats, sizes)
        end
      end

      def get_paths?(moji, formats = Emojidex::Defaults.formats, sizes = Emojidex::Defaults.sizes)
        paths = {}
        path = "#{@vector_source_path}/#{moji.code}.svg"
        paths[:svg] = path if File.exist? path
        if formats.include? :png
          paths[:png] = {}
          sizes.keys.each do |size|
            path = "#{@raster_source_path}/#{size}/#{moji.code}.png"
            paths[:png][size] = path if File.exist? path
          end
        end
        paths
      end

      def get_paths(moji, formats = Emojidex::Defaults.formats,
                    sizes = Emojidex::Defaults.sizes)
        paths = {}
        paths[:svg] = "#{@vector_source_path}/#{moji.code}.svg"
        if formats.include? :png
          paths[:png] = {}
          sizes.keys.each do |size|
            paths[:png][size] = "#{@raster_source_path}/#{size}/#{moji.code}.png"
          end
        end
        paths
      end

      private

      def _checksum_for_file(path)
        sum = nil
        if File.exist? path
          sum = Digest::MD5.file(path).hexdigest
        end
        sum
      end
    end
  end
end
