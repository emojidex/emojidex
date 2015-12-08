# encoding: utf-8

require 'json'
require_relative 'emoji'
require_relative 'categories'
require_relative 'collection/cache'
require_relative 'collection/asset_information'
require_relative 'collection/moji_data'

module Emojidex
  module Data
    # listing and search of standard UTF emoji
    class Collection
      include Emojidex::Data::CollectionCache
      include Emojidex::Data::CollectionAssetInformation
      include Emojidex::Data::CollectionMojiData
      attr_accessor :emoji, :categories,
                    :source_path, :vector_source_path, :raster_source_path

      # Initialize Collection. You can pass a list of emoji to seed the collection
      def initialize(emoji_list = nil, local_load_path = nil)
        @emoji = {}
        @raster_source_path = @vector_source_path = @source_path = nil
        load_local_collection(local_load_path) unless local_load_path.nil?
        add_emoji(emoji_list) unless emoji_list.nil?
        @emoji
      end

      # Loads an emoji collection on local storage
      def load_local_collection(path)
        @source_path = File.expand_path(path)
        json = IO.read(@source_path + '/emoji.json')
        list = JSON.parse(json, symbolize_names: true)
        add_emoji(list)
      end

      # each override to map each functionality to the emoji hash values
      def each(&block)
        @emoji.values.each(&block)
      end

      # select override to map select functionality to the emoji hash values
      def select(&block)
        @emoji.values.select(&block)
      end

      def map(&block)
        @emoji.values.map(&block)
      end

      def collect(&block)
        @emoji.values.collect(&block)
      end

      # Retreives an Emoji object by the actual moji code/character code
      # Will likely only return moji from UTF collection
      def find_by_moji(moji)
        each do |m|
          return m if m[:moji] == moji
        end
        nil
      end

      alias_method :文字検索, :find_by_moji

      # Gets the emoji with the specified code
      # Returns the Emoji object or nil if no emoji with that code is found
      def find_by_code(code)
        @emoji[code.gsub(/\s/, '_').to_sym]
      end

      # Locates emoji by Japanese code (original Japanese emoji name [絵文字名])
      # Only applies to collections that contain JA codes, this function is mapped to
      # find_by_code for all other implementations (such as client)
      def find_by_code_ja(code_ja)
        each do |m|
          return m if m[:code_ja] == code_ja
        end
        nil
      end

      alias_method :コード検索, :find_by_code_ja

      def find_by_unicode(unicode)
        unicode = unicode.downcase
        each do |m|
          return m if m[:unicode] == unicode
        end
        nil
      end

      def search(criteria = {})
        Emojidex::Data::Collection.new _sub_search(@emoji.values.dup, criteria)
      end

      # Get all emoji from this collection that are part of the specified category
      # Returns a new collection of only emoji in the specified category
      def category(category_code)
        categorized = @emoji.values.select { |moji| moji.category == category_code }
        Emojidex::Data::Collection.new categorized
      end

      # Check to see if there are emoji in this collection which have the specified categories
      # Returns true if there are emoji for all secified categories within this collection
      def category?(*category_codes)
        (category_codes.uniq - @categories).empty?
      end

      # Adds emojis to the collection
      # After add categories are updated
      def add_emoji(list)
        list.each do |moji_info|
          if moji_info.instance_of? Emojidex::Data::Emoji
            @emoji[moji_info.code.to_sym] = moji_info.dup
          else
            emoji = Emojidex::Data::Emoji.new moji_info
            @emoji[emoji.code.to_sym] = emoji
          end
        end
        categorize
        associate_variants
        condense_moji_code_data
        @emoji
      end

      alias_method :<<, :add_emoji

      private

      # Makes a list of all categories which contain emoji in this collection
      def categorize
        @categories = @emoji.values.map { |moji| moji.category }
        @categories.uniq!
      end

      def associate_variants
        @emoji.values.each do |emoji_obj|
          if emoji_obj.code.match(/\(.*\)$/) # this emoji is a variant
            # check for base
            base_code = emoji_obj.code.sub(/\(.*\)$/, '').to_sym
            if @emoji.key? base_code
              @emoji[base_code].variants << emoji_obj.code.to_sym
              emoji_obj.base = base_code
            end
          end
        end
      end

      def _sub_search(list, criteria = {})
        cr = criteria.shift
        return list if cr.nil?

        list = list.select { |moji| moji if moji[cr[0]] =~ /#{cr[1]}/ }
        _sub_search(list, criteria)
      end
    end
  end
end
