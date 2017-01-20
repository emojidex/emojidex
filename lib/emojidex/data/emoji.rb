require_relative '../../emojidex'
require_relative 'emoji/combination_information'
require_relative 'emoji/asset_information'

module Emojidex
  module Data
    # emoji base class
    class Emoji
      # Attribute Definitions:
      # * moji: the actual character code associated with this emoji (if any)
      # * category: category this emoji belongs to (usually as defined by Unicode)
      # * code: the "short code" for the emoji
      # * code_ja: the Japanese version of the "short code"
      # * unicode: a string representing the hex of the unicode characters with - between multiples
      # * tags: the tags registered to this emoji (usually only from the service)
      # * emoticon: the emoticon that maps to this emoji (rarely used/not recommended)
      # * variants: different (variants) of the emoji EG: racial modifiers
      # * base: the base variant EG: the base emoji without modifiers
      # * r18: flag indicating adult content
      attr_accessor :moji, :category, :code, :code_ja,
                    :unicode, :tags, :emoticon, :variants, :base,
                    :r18

      include Emojidex::Data::EmojiCombinationInformation
      include Emojidex::Data::EmojiAssetInformation

      def initialize(details = {})
        _init_identifier_info(details)
        _init_descriptor_info(details)
        init_combination_info(details)
        init_asset_info(details)
      end

      def to_s
        @moji || Emojidex.encapsulate_code(@code)
      end

      def to_json(*args)
        hash = to_hash
        hash.each do |key, val|
          hash.delete(key) if (val.instance_of?(Array) && val.length == 0)
          hash.delete(key) if (val.instance_of?(String) && val == "")
        end
        hash.to_json(*args)
      end

      def to_hash
        hash = {}
        instance_variables.each do |key|
          hash[key.to_s.delete('@')] = instance_variable_get(key)
        end
        hash
      end

      def [](key)
        instance_variable_get(key.to_s.delete(':').insert(0, '@'))
      end

      def []=(key, val)
        instance_variable_set(key.to_s.delete(':').insert(0, '@'), val)
      end

      private

      def _init_identifier_info(details)
        @moji = details[:moji].to_s
        @code = Emojidex.escape_code(details[:code].to_s)
        @code_ja = Emojidex.escape_code(details[:code_ja].to_s)
        @unicode = details[:unicode].to_s
        @full_name = details[:full_name].to_s
        @emoticon = details[:emoticon].to_s
        @r18 = details[:r18] || false
      end

      def _init_descriptor_info(details)
        @category = details[:category] ? details[:category].to_sym : :other
        @tags = details[:tags].map(&:to_sym) unless details[:tags].nil?
        @link = details[:link].to_s
        @variants = details[:variants] || []
        @variants.uniq!
        @base = details[:base]
        @is_wide = details[:is_wide]
      end
    end
  end
end
