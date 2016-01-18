module Emojidex
  module Service
    class HistoryItem
      attr_accessor :emoji_code, :times_used, :last_used

      def initialize(data = {})
        @emoji_code = data[:emoji_code] || ''
        @times_used = data[:times_used] || ''
        @last_used = data[:last_used] || ''
      end

      def to_json(*a)
        {
          emoji_code: @emoji_code,
          times_used: @times_used,
          last_used: @last_used
        }.to_json(*a)
      end
    end
  end
end
