module Emojidex
  module Data
    # collects and condenses UTF moji codes within a collection
    module CollectionMojiData
      attr_reader :moji_code_string, :moji_code_index

      def condense_moji_code_data
        @moji_code_string = ''
        @moji_code_index = {}

        @emoji.values.each do |moji|
          unless moji.moji.nil?
            @moji_code_string << moji.moji
            @moji_code_index[moji.moji] = moji.code
          end
        end
      end
    end
  end
end
