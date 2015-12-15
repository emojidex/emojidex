require_relative '../../emojidex'
require_relative 'emoji/asset_information'

module Emojidex
  module Data
    # emoji base class
    class Emoji
      attr_accessor :moji, :category, :code, :code_ja,
                    :unicode, :tags, :emoticon, :variants, :base

      include Emojidex::Data::EmojiAssetInformation

      def initialize(details = {})
        _init_identifier_info(details)
        _init_descriptor_info(details)
        init_asset_info(details)
      end

      def to_s
        @moji || Emojidex.encapsulate_code(@code)
      end

      def to_json(*args)
        to_hash.to_json(*args)
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
      end

      def _init_descriptor_info(details)
        @category = details[:category] ? details[:category].to_sym : :other
        @tags = details[:tags].map(&:to_sym) unless details[:tags].nil?
        @link = details[:link].to_s
        @variants = details[:variants] || []
        @base = details[:base]
        @is_wide = details[:is_wide]
      end
    end
  end
end
