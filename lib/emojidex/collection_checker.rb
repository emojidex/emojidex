
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
      check_cache_only(collections, cache_files, sizes, formats)
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
        result["#{prefix}#{File.basename(file, '.*')}".to_sym] = "#{prefix}#{file}" if File.extname(file) == ext
      end
      result
    end

    def check_collection_only(collections, cache_files, sizes, formats)
      collections.each do |collection|
        collection.emoji.values.each do |emoji|
          tmp = []
          if formats.include?(':svg') && cache_files[emoji.code.to_sym].nil?
            tmp << emoji.code
          end
          if formats.include?(':png')
            sizes.each do |size|
              name = "#{size}/#{emoji.code}"
              tmp << name if cache_files[name.to_sym].nil?
            end
          end
          @collection_only_emojis[emoji.code.to_sym] = tmp unless tmp.empty?
        end
      end
    end

    def check_cache_only(collections, cache_files, sizes, formats)
      cache_files.each do |key, value|
        name = File.basename(value, '.*')
        is_find = false
        collections.each do |collection|
          unless collection.emoji[name.to_sym].nil?
            is_find = true
            break
          end
        end

        unless is_find
          symbol = name.to_sym
          @cache_only_emojis[symbol] = [] if @cache_only_emojis[symbol].nil?
          @cache_only_emojis[symbol] << value
        end
      end
    end
  end # class CollectionChecker
end # module Emojidex
