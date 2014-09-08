require_relative 'emoji/asset_information'

module Emojidex
  # emoji base class
  class Emoji
    attr_accessor :moji, :category, :code, :unicode,
                  :tags, :emoticon

    include Emojidex::EmojiAssetInformation

    def initialize(details = {})
      @moji = details[:moji]
      @code, @code_ja = details[:code], details[:code_ja]
      @unicode = details[:unicode]
      @emoticon = details[:emoticon]
      @category = details[:category] ? details[:category].to_sym : :other
      @tags = details[:tags].map { |tag| tag.to_sym } unless details[:tags].nil?
      @link = details[:link]
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
