require 'json'
require 'fileutils'
require_relative 'asset_information'
require_relative '../../service/transactor'
require_relative '../../defaults'

module Emojidex
  module Data
    # local caching functionality for collections
    module CollectionCache
      include Emojidex::Data::CollectionAssetInformation
      attr_reader :cache_path

      def setup_cache(path = nil)
        # check if cache dir is already set
        return @cache_path if @cache_path && path.nil?
        # setup cache
        @cache_path = File.expand_path(path || ENV['EMOJI_CACHE'] || "#{ENV['HOME']}/.emojidex/emoji/")
        # ENV['EMOJI_CACHE'] = @cache_path
        FileUtils.mkdir_p(@cache_path)
        Emojidex::Defaults.sizes.keys.each do |size|
          FileUtils.mkdir_p(@cache_path + "/#{size}")
        end
        @cache_path
      end

      # Caches emoji to local emoji storage cache
      # Options:
      #   cache_path: manually specify cache location
      #     (default is ENV['EMOJI_CACHE'] or '$HOME/.emoji_cache')
      #   formats: formats to cache (default is SVG only)
      #   sizes: sizes to cache (default is px32, but this is irrelivant for SVG)
      def cache!(options = {})
        setup_cache options[:cache_path]
        formats = options[:formats] || Emojidex::Defaults.selected_formats
        sizes = options[:sizes] || Emojidex::Defaults.selected_sizes
        thr = []
        @emoji.values.each do |moji|
          thr << Thread.new { _svg_check_copy(moji) } if formats.include? :svg
          thr << Thread.new { _raster_check_copy(moji, :png, sizes) } if formats.include? :png
          if thr.length >= 8
            thr.each { |t| t.join }
            thr = []
          end
        end
        cache_index
      end

      def cache_index(destination = nil)
        destination ||= @cache_path
        idx = Emojidex::Data::Collection.new
        idx.load_local_collection(destination) if FileTest.exist? "#{destination}/emoji.json"
        idx.add_emoji @emoji.values
        File.open("#{destination}/emoji.json", 'w') do |f|
          f.write idx.emoji.values.to_json
        end
      end

      def write_index(destination)
        idx = @emoji.values.to_json
        idx = JSON.parse idx
        idx.each { |moji| moji.delete_if{ |k, v| v.nil? }}
        File.open("#{destination}/emoji.json", 'w') { |f| f.write idx.to_json }
      end

      private

      def _svg_check_copy(moji)
        _cache_vector_from_net(moji, format, sizes) if @vector_source_path.nil? && @source_path.nil?
        @vector_source_path = @source_path if @vector_source_path.nil?
        src = "#{@vector_source_path}/#{moji.code}"
        if File.exist? "#{src}.svg"
          unless File.exist?("#{@cache_path}/#{moji.code}.svg") &&
              FileUtils.compare_file("#{src}.svg", "#{@cache_path}/#{moji.code}.svg")
            FileUtils.cp("#{src}.svg", @cache_path)
          end
        else
          _cache_svg_from_net(moji)
        end
        FileUtils.cp_r src, @cache_path if File.directory? src
      end

      def _raster_check_copy(moji, format, sizes)
        _cache_raster_from_net(moji, format, sizes) if @raster_source_path.nil? && @source_path.nil?
        @raster_source_path = @source_path if @raster_source_path.nil?
        _cache_raster_from_net(moji, format, sizes) if @raster_source_path.nil?
        sizes.each do |size|
          src = "#{@raster_source_path}/#{size}/#{moji.code}"
          if FileTest.exist? "#{src}.#{format}"
            FileUtils.cp("#{src}.#{format}", ("#{@cache_path}/#{size}"))
          else 
            _cache_raster_from_net(moji, format, sizes)
          end
          FileUtils.cp_r(src, @cache_path) if File.directory? src
        end
      end

      def _cache_from_net(moji, formats, sizes)
        formats = *formats unless formats.class == Array
        dls = []
        dls << Thread.new { _cache_svg_from_net(moji) } if formats.include? :svg
        dls << Thread.new { _cache_raster_from_net(moji, :png, sizes) } if formats.include? :png
        dls.each { |t| t.join }
      end

      def _cache_svg_from_net(moji)
        target = "#{@cache_path}/#{moji.code}.svg"
        if File.exist? target # check for an existing copy so we don't double downlaod
          return if moji.checksum?(:svg).nil? # no updates if we didn't get details
          # if the checksums are the same there is no reason to update
          return if moji.checksum?(:svg) == get_checksums(moji, [:svg])[:svg]
        end
        response = Emojidex::Service::Transactor.download("#{moji.code}.svg")
        File.open(target, 'wb') { |fp| 
          fp.write(response.body) }
      end

      def _cache_raster_from_net(moji, format, sizes)
        sizes.each do |size|
          response = Emojidex::Service::Transactor.download("#{size}/#{moji.code}.#{format.to_s}")
          File.open("#{@cache_path}/#{size}/#{moji.code}.#{format.to_s}", 'wb') { |fp| 
            fp.write(response.body) }
        end
      end
    end
  end
end
