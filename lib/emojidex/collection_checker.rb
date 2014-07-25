
require 'find'
require_relative 'defaults.rb'

module Emojidex
  # Check collections for presence of image assets and discrepencies in emoji indexes.
  class CollectionChecker
    attr_reader :index_only_emoji, :asset_only_emoji

    def initialize(collections, asset_dir, sizes = Defaults.sizes, formats = Defaults.formats)
      @index_only_emoji = {}
      @asset_only_emoji = {}
      asset_files = create_asset_file_list(asset_dir, sizes, formats)
      check_collection_only(collections, asset_files, sizes, formats)
      check_assets_only(collections, asset_files)
    end

    private

    def create_asset_file_list(dir, sizes, formats)
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

    def check_collection_only(collections, asset_files, sizes, formats)
      collections.each do |collection|
        collection.emoji.values.each do |emoji|
          tmp = []
          tmp += create_svg_array(emoji, asset_files) if formats.include?(':svg')
          tmp += create_png_array(emoji, asset_files, sizes) if formats.include?(':png')
          @index_only_emoji[emoji.code.to_sym] = tmp unless tmp.empty?
        end
      end
    end

    def create_svg_array(emoji, asset_files)
      result = []
      result << emoji.code if asset_files[emoji.code.to_sym].nil?
      result
    end

    def create_png_array(emoji, asset_files, sizes)
      result = []
      sizes.each do |size|
        name = "#{size}/#{emoji.code}"
        result << name if asset_files[name.to_sym].nil?
      end
      result
    end

    def check_assets_only(collections, asset_files)
      asset_files.each do |_key, value|
        code = File.basename(value, '.*')

        next if find_emoji_from_collections(collections, code)

        symbol = code.to_sym
        @asset_only_emoji[symbol] = [] if @asset_only_emoji[symbol].nil?
        @asset_only_emoji[symbol] << value
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
