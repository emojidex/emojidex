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
          moji.combinations.each do |combo|
            combo.checksums = get_combo_checksums(moji, combo, formats, sizes)
          end
          moji.customizations.each do |combo|
            combo.checksums = get_combo_checksums(moji, combo, formats, sizes)
          end
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

      def get_combo_checksums(moji, combo, formats = Emojidex::Defaults.formats,
                        sizes = Emojidex::Defaults.sizes)
        sums = combo.generate_blank_entry_set
        if formats.include? :svg
          for i in 0..(combo.components.length - 1)
            combo.components[i].each do |component|
              sums[i][component][:svg] = _checksum_for_file("#{@vector_source_path}/#{combo.base}/#{i}/#{component}.svg")
            end
          end
        end
        if formats.include? :png
          sizes.keys.each do |size|
            for i in 0..(combo.components.length - 1)
              combo.components[i].each do |component|
                sums[i][component][:png] = _checksum_for_file("#{@raster_source_path}/#{size}/#{combo.base}/#{i}/#{component}.png")
              end
            end
          end
        end
        sums
      end

      def generate_paths(formats = Emojidex::Defaults.formats, sizes = Emojidex::Defaults.sizes)
        @emoji.values.each do |moji|
          moji.paths = get_paths(moji, formats, sizes)
          moji.combinations.each do |combo|
            combo.paths = get_combo_paths(moji, combo, formats, sizes)
          end
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

      def get_combo_paths(moji, combo, formats = Emojidex::Defaults.formats,
                    sizes = Emojidex::Defaults.sizes)
        paths = combo.generate_blank_path_set
        paths[:svg] = "#{@vector_source_path}/#{moji.code}"
        if formats.include? :png
          sizes.keys.each do |size|
            paths[:png][size] = "#{@raster_source_path}/#{size}/#{moji.code}"
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
