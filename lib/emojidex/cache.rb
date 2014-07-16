require 'json'
require_relative 'defaults'
require 'fileutils'

module Emojidex
  # local caching functionality for collections
  module Cache
    attr_reader :cache_dir

    def setup_cache(path = nil)
      # check if cache dir is already set
      return @cache_dir if @cache_dir && path.nil?
      # setup cache
      @cache_dir = File.expand_path(path || ENV['EMOJI_CACHE'] || "#{ENV['HOME']}/.emojidex/cache")
      FileUtils.mkdir_p(@cache_dir)
      Emojidex::Defaults.sizes.keys.each do |size|
        FileUtils.mkdir_p(@cache_dir + "/#{size}")
      end
      @cache_dir
    end

    # Caches emoji to local emoji storage cache
    # Options:
    #   cache_dir: manually specify cache location
    #     (default is ENV['EMOJI_CACHE'] or '$HOME/.emoji_cache')
    #   formats: formats to cache (default is SVG only)
    #   sizes: sizes to cache (default is px32, but this is irrelivant for SVG)
    def cache!(options = {})
      setup_cache options[:cache_dir]
      formats = options[:formats] || [:svg, :png]
      sizes = options[:sizes] || [:px32]
      @emoji.values.each do |moji|
        _svg_check_copy(moji) if formats.include? :svg
        _raster_check_copy(moji, :png, sizes) if formats.include? :png
      end
      cache_index
    end

    def cache_index(destination = nil)
      destination = destination || @cache_dir
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
        unless File.exist?("#{@cache_dir}/#{moji.code}.svg") &&
          FileUtils.compare_file("#{src}.svg", "#{@cache_dir}/#{moji.code}.svg")
          FileUtils.cp("#{src}.svg", @cache_dir)
        end
      end
      FileUtils.cp_r src, @cache_dir if File.directory? src
    end

    def _raster_check_copy(moji, format, sizes)
      sizes.each do |size|
        src = @source_path + "/#{size}/#{moji.code}"
        FileUtils.cp "src.#{format}", (@cache_dir + "/#{size}") if FileTest.exist? "src.#{format}"
        FileUtils.cp_r src, @cache_dir if File.directory? src
      end
    end
  end
end
