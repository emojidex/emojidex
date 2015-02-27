module Emojidex
  module API
    module Search
      # Search API for emoji
      module Emoji
        def emoji_code_cont(term, options = {})
          response = get(
                          '/api/v1/search/emoji.json',
                          options.merge('q[code_cont]' => term)
                        )
          response[:body]
        end
      end
    end
  end
end
