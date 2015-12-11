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
        sums[:svg] = _checksum_for_file("#{@cache_path}/#{moji.code}.svg") if formats.include? :svg
        if formats.include? :png
          sums[:png] = {}
          sizes.keys.each do |size|
            sums[:png][size] = _checksum_for_file("#{@cache_path}/#{size}/#{moji.code}.png")
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
        path = "#{@cache_path}/#{moji.code}.svg"
        paths[:svg] = path if File.exist? path
        if formats.include? :png
          paths[:png] = {}
          sizes.keys.each do |size|
            path = "#{@cache_path}/#{size}/#{moji.code}.png"
            paths[:png][size] = path if File.exist? path
          end
        end
        paths
      end

      def get_paths(moji, formats = Emojidex::Defaults.formats,
                    sizes = Emojidex::Defaults.sizes)
        paths = {}
        paths[:svg] = "#{@cache_path}/#{moji.code}.svg"
        if formats.include? :png
          paths[:png] = {}
          sizes.keys.each do |size|
            paths[:png][size] = "#{@cache_path}/#{size}/#{moji.code}.png"
          end
        end
        paths
      end

      private

      def _checksum_for_file(path)
        (File.exist? path) ? Digest::MD5.file(path).hexdigest : nil
      end
    end
  end
end
