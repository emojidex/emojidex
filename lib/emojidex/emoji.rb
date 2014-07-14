#
# Emojidex::Emoji
#
module Emojidex
  # emoji base class
  class Emoji
    attr_accessor :moji, :category, :code, :unicode,
                  :tags, :frames, :delays

    def initialize(details = {})
      @moji = details[:moji]
      @code, @code_ja = details[:code], details[:code_ja]
      @unicode = details[:unicode]
      @category = details[:category] ? details[:category].to_sym : :other
      @tags = details[:tags].map { |tag| tag.to_sym } unless details[:tags].nil?
      @frames = details[:frames] || [@code]
      @delays = details[:delays] || [100]
      @loops = details[:loops]
      @link = details[:link]
      @is_wide = details[:is_wide]
    end

    def to_s
      @moji || ':' + @code + ':'
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

    def set_animation_data(params)
      set_frames(params)
      set_delays(params)
    end

    def set_frames(params)
      return if params[:frames].nil?

      @frames = params[:frames].clone
      params[:frames].each_with_index do |frame, i|
        @frames[i] = frame.keys.first.to_s if frame.is_a? Hash
      end
    end

    def set_delays(params)
      default_delay = params[:default_delay] || 100

      @delays = params[:delays] unless params[:delays].nil?
      if @delays.length < @frames.length
        @delays << default_delay until @delays.length == @frames.length
      end
    end

    def animated?
      @frames.count > 1
    end
  end
end
