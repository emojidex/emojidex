module Emojidex
  module API
    # Get emoji from API
    module Emoji
      def emoji(*args)
        response = get('/api/v1/emoji.json', args)
        response[:body]['emoji']
      end

      def single_emoji(*args)
        response = get('/api/v1/emoji/emoji.json', args)
        response[:body]
      end

      def emoji_detailed(*args)
        response = get('/api/v1/emoji/detailed.json', args)
        response[:body]
      end

      def single_emoji_detailed(*args)
        response = get('/api/v1/emoji/1/detailed.json', args)
        response[:body]
      end
    end
  end
end
