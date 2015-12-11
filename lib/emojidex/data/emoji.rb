require_relative 'emoji/asset_information'

module Emojidex::Data
  # emoji base class
  class Emoji
    attr_accessor :moji, :category, :code, :code_ja,
                  :unicode, :tags, :emoticon, :variants, :base

    include Emojidex::Data::EmojiAssetInformation

    def initialize(details = {})
      init_asset_info(details)
      @moji = details[:moji]
      @code, @code_ja = details[:code], details[:code_ja]
      @unicode, @full_name = details[:unicode], details[:full_name]
      @emoticon = details[:emoticon]
      @category = details[:category] ? details[:category].to_sym : :other
      @tags = details[:tags].map(&:to_sym) unless details[:tags].nil?
      @link = details[:link]
      @variants, @base = details[:variants] || [], details[:base]
      @is_wide = details[:is_wide]
    end

    def to_s
      @moji || ":#{@code}:"
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
  end
end
