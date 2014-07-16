
require 'find'
require_relative 'defaults.rb'

module Emojidex
  # Check collection.
  class CollectionChecker
    attr_reader :collection_only_emojis, :cache_only_emojis

    def initialize(collections, cache_dir, sizes = Defaults.sizes, formats = Defaults.formats)
      @collection_only_emojis = {}
      @cache_only_emojis = {}
      cache_files = create_cache_file_list(cache_dir, sizes, formats)
      check_collection_only(collections, cache_files, sizes, formats)
      check_cache_only(collections, cache_files)
    end

    private

    def create_cache_file_list(dir, sizes, formats)
      result = {}
      result.merge!(create_file_list(dir, '.svg', '')) if formats.include?(':svg')
      if formats.include?(':png')
        sizes.each do |size|
          result.merge!(create_file_list("#{dir}/#{size}", '.png', "#{size}/"))
        end
      end
      result
    end

    def create_file_list(dir, ext, prefix)
      result = {}
      Dir.foreach(dir) do |file|
        result["#{prefix}#{File.basename(file, '.*')}".to_sym] =
          "#{prefix}#{file}" if File.extname(file) == ext
      end
      result
    end

    def check_collection_only(collections, cache_files, sizes, formats)
      collections.each do |collection|
        collection.emoji.values.each do |emoji|
          tmp = []
          tmp += create_svg_array(emoji, cache_files) if formats.include?(':svg')
          tmp += create_png_array(emoji, cache_files, sizes) if formats.include?(':png')
          @collection_only_emojis[emoji.code.to_sym] = tmp unless tmp.empty?
        end
      end
    end

    def create_svg_array(emoji, cache_files)
      result = []
      result << emoji.code if cache_files[emoji.code.to_sym].nil?
      result
    end

    def create_png_array(emoji, cache_files, sizes)
      result = []
      sizes.each do |size|
        name = "#{size}/#{emoji.code}"
        result << name if cache_files[name.to_sym].nil?
      end
      result
    end

    def check_cache_only(collections, cache_files)
      cache_files.each do |_key, value|
        code = File.basename(value, '.*')

        next if find_emoji_from_collections(collections, code)

        symbol = code.to_sym
        @cache_only_emojis[symbol] = [] if @cache_only_emojis[symbol].nil?
        @cache_only_emojis[symbol] << value
      end
    end

    def find_emoji_from_collections(collections, code)
      symbol = code.to_sym
      collections.each do |collection|
        return true unless collection.emoji[symbol].nil?
      end
      false
    end
  end # class CollectionChecker
end # module Emojidex
