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
      attr_reader :cache_path, :download_queue
      attr_accessor :download_threads

      def setup_cache(path = nil)
        @download_queue = []
        @download_threads = 8
        # check if cache dir is already set
        return @cache_path if @cache_path && path.nil?
        # setup cache
        @cache_path =
          File.expand_path((path || Emojidex::Defaults.system_cache_path) + '/emoji')
        # ENV['EMOJI_CACHE'] = @cache_path
        FileUtils.mkdir_p(@cache_path)
        Emojidex::Defaults.sizes.keys.each do |size|
          FileUtils.mkdir_p(@cache_path + "/#{size}")
        end
        # load will expect emoji.json even if it contains no emoji
        unless File.exist? "#{cache_path}/emoji.json"
          File.open("#{@cache_path}/emoji.json", 'w') { |f| f.write '[]' }
        end
        @cache_path
      end

      def load_cache(path = nil)
        setup_cache(path)
        load_local_collection(@cache_path)
      end

      # Caches emoji to local emoji storage cache
      # Options:
      #   cache_path: manually specify cache location
      #     (default is ENV['EMOJI_CACHE'] or '$HOME/.emoji_cache')
      #   formats: formats to cache (default is SVG only)
      #   sizes: sizes to cache (default is px32, but this is irrelivant for SVG)
      def cache(options = {})
        _cache(options)
        cache_index
      end

      # Caches emoji to local emoji storage cache
      # +regenerates checksums and paths
      # Options:
      #   cache_path: manually specify cache location
      #     (default is ENV['EMOJI_CACHE'] or '$HOME/.emoji_cache')
      #   formats: formats to cache (default is SVG only)
      #   sizes: sizes to cache (default is px32, but this is irrelivant for SVG)
      def cache!(options = {})
        _cache(options)
        generate_paths
        generate_checksums
        cache_index
      end

      # Updates an index in the specified destination (or the cache path if not specified).
      # This method reads the existing index, combines the contents with this collection, and
      # writes the results.
      def cache_index(destination = nil)
        destination ||= @cache_path
        idx = Emojidex::Data::Collection.new
        idx.load_local_collection(destination) if FileTest.exist? "#{destination}/emoji.json"
        idx.add_emoji @emoji.values
        #File.open("#{destination}/emoji.json", 'w') { |f| f.write idx.emoji.values.to_json }
        write_index(destination)
      end

      # [over]writes a sanitized index to the specified destination.
      # WARNING: This method destroys any index files in the destination.
      def write_index(destination)
        idx = @emoji.values.to_json
        idx = JSON.parse idx
        idx.each do |moji|
          moji['paths'] = nil
          moji['local_checksums'] = nil
          moji.delete_if { |_k, v| v.nil? }
        end
        File.open("#{destination}/emoji.json", 'w') { |f| f.write idx.to_json }
      end

      private

      def _svg_check_copy(moji)
        src = "#{@vector_source_path}/#{moji.code}.svg"
        if File.exist? "#{src}"
            FileUtils.cp("#{src}", @cache_path) unless @vector_source_path == @cache_path
        else
          @download_queue << { moji: moji, formats: :svg, sizes: [] }
        end
        FileUtils.cp_r src, @cache_path if File.directory? src # Copies source frames and data files if unpacked
      end

      def _raster_check_copy(moji, format, sizes)
        sizes.each do |size|
          src = "#{@raster_source_path}/#{size}/#{moji.code}"
          if File.exist? "#{src}.#{format}"
            FileUtils.cp("#{src}.#{format}", ("#{@cache_path}/#{size}")) unless @raster_source_path == @cache_path
          else
            @download_queue << { moji: moji, formats: [format], sizes: [size] }
          end
          FileUtils.cp_r(src, @cache_path) if File.directory? src # Copies source frames and data files if unpacked
        end
      end

      def _process_download_queue
        thr = []
        @download_queue.each do |dl|
          thr << Thread.new { _cache_from_net(dl[:moji], dl[:formats], dl[:sizes]) }
          thr.each(&:join) if thr.length >= @download_threads
        end
        thr.each(&:join) # grab end of queue
      end

      def _cache_from_net(moji, formats, sizes)
        formats = *formats unless formats.class == Array
        dls = []
        dls << Thread.new { moji.cache(:svg) } if formats.include? :svg
        dls << Thread.new { moji.cache(:png, sizes) } if formats.include? :png
        dls.each(&:join)
      end

      def _cache(options)
        setup_cache options[:cache_path]
        formats = options[:formats] || Emojidex::Defaults.selected_formats
        sizes = options[:sizes] || Emojidex::Defaults.selected_sizes
        
        @vector_source_path = @cache_path if @vector_source_path.nil?
        @raster_source_path = @cache_path if @raster_source_path.nil?
        
        @emoji.values.each do |moji|
          _svg_check_copy(moji) if formats.include? :svg
          _raster_check_copy(moji, :png, sizes) if formats.include? :png
        end
        _process_download_queue

        @vector_source_path = @cache_path if formats.include? :svg
        @raster_source_path = @cache_path if formats.include? :png
      end
    end
  end
end
