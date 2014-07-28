require 'json'
require_relative 'defaults'
require 'fileutils'

module Emojidex
  # local caching functionality for collections
  module Cache
    attr_reader :cache_path

    def setup_cache(path = nil)
      # check if cache dir is already set
      return @cache_path if @cache_path && path.nil?
      # setup cache
      @cache_path = File.expand_path(path || ENV['EMOJI_CACHE'] || "#{ENV['HOME']}/.emojidex/cache")
      ENV['EMOJI_CACHE'] = @cache_path
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
      formats = options[:formats] || [:svg, :png]
      sizes = options[:sizes] || [:px32]
      @emoji.values.each do |moji|
        _svg_check_copy(moji) if formats.include? :svg
        _raster_check_copy(moji, :png, sizes) if formats.include? :png
      end
      cache_index
    end

    def cache_index(destination = nil)
      destination ||= @cache_path
      idx = Emojidex::Collection.new
      idx.load_local_collection(destination) if FileTest.exist? "#{destination}/emoji.json"
      idx.add_emoji @emoji.values
      File.open("#{destination}/emoji.json", 'w') do |f|
        f.write idx.emoji.values.to_json
      end
    end

    private

    def _svg_check_copy(moji)
      src = @source_path + "/#{moji.code}"
      if File.exist? "#{src}.svg"
        unless File.exist?("#{@cache_path}/#{moji.code}.svg") &&
          FileUtils.compare_file("#{src}.svg", "#{@cache_path}/#{moji.code}.svg")
          FileUtils.cp("#{src}.svg", @cache_path)
        end
      end
      FileUtils.cp_r src, @cache_path if File.directory? src
    end

    def _raster_check_copy(moji, format, sizes)
      sizes.each do |size|
        src = @source_path + "/#{size}/#{moji.code}"
        FileUtils.cp "#{src}.#{format}", (@cache_path + "/#{size}") if FileTest.exist? "#{src}.#{format}"
        FileUtils.cp_r src, @cache_path if File.directory? src
      end
    end
  end
end
