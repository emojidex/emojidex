require 'digest/md5'
require_relative '../../defaults'

module Emojidex
  module Data
    # Asset information for emoji
    module EmojiAssetInformation
      attr_accessor :checksums, :paths, :local_checksums

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
        @local_checksums = @checksums.dup
      end

      def fill_checksums(checksums)
        @checksums[:svg] = checksums[:svg] if checksums.include? :svg
        return unless checksums.include? :png
        Emojidex::Defaults.sizes.keys.each do |size|
          @checksums[:png][size] = checksums[:png][size] if checksums[:png].include? size
        end
      end

      def blank_paths
        @paths = {}
        @paths[:svg] = nil
        @paths[:png] = {}
        Emojidex::Defaults.sizes.keys.each do |size|
          @paths[:png][size] = nil
        end
      end

      def fill_paths(paths)
        @paths[:svg] = paths[:svg] if paths.include? :svg
        return unless paths.include? :png
        Emojidex::Defaults.sizes.keys.each do |size|
          @paths[:png][size] = paths[:png][size] if paths[:png].include? size
        end
      end

      # Acquires path and caches the target file if not found or out of date
      def path(format, size = nil)
        fp = path?(format, size)
        cache(format, [size]) unless !fp.nil? && File.exist?(fp)
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

      # Caches a file of the specified format in the specified sizes
      def cache(format, sizes = nil)
        generate_local_checksums
        case format
        when :png
          _cache_png(sizes) unless sizes.nil?
        when :svg
          _cache_svg
        end
      end

      # Generates a checksum for each locally cached file
      def generate_local_checksum(format, size = nil)
        case format
        when :png
          return @local_checksums[:png][size] = _checksum_for_file(@paths[:png][size])
        when :svg
          return @local_checksum[:svg] = _checksum_for_file(@paths[:svg])
        end
        nil
      end

      def generate_local_checksums
        @local_checksums[:svg] = _checksum_for_file(@paths[:svg])
        @paths[:png].keys.each do |size|
          @local_checksums[:png][size] = _checksum_for_file(@paths[:png][size])
        end
        @local_checksums
      end

      private

      def _cache_svg
        @paths[:svg] = Dir.pwd unless (@paths.include? :svg) && !@paths[:svg].nil?
        return if File.exist?(@paths[:svg]) && !@checksums[:svg].nil? &&
                  @checksums[:svg] == generate_local_checksum(:svg)
        response = Emojidex::Service::Transactor.download("#{@code}.svg")
        File.open(@paths[:svg], 'wb') { |fp| fp.write(response.body) }
        generate_local_checksum(:svg)
      end

      def _cache_png(sizes)
        sizes = sizes.keys if sizes.is_a?(Hash)
        sizes.each do |size|
          size = size.first if size.is_a?(Array)
          size = size.key if size.is_a?(Hash)
          unless @paths.include?(:png) &&
                 @paths[:png].include?(size) && @paths[:png][size].nil? == false
            @paths[:png][size] = "#{Dir.pwd}/#{size}/#{@code}.png"
          end
          next if File.exist?(@paths[:png][size]) &&
                  !@checksums[:png][size].nil? &&
                  @checksums[:png][size] == generate_local_checksum(:png, size)
          response = Emojidex::Service::Transactor.download("#{size}/#{@code}.png")
          File.open(@paths[:png][size], 'wb') { |fp| fp.write(response.body) }
          generate_local_checksum(:png, size)
        end
      end

      def _checksum_for_file(path)
        (File.exist? path) ? Digest::MD5.file(path).hexdigest : nil
      end
    end
  end
end
