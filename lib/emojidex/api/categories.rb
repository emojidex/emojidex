module Emojidex
  module API
    # Get cateegories from API
    module Categories
      def categories(*args)
        response = get('/api/v1/categories.json', args)
        response[:body]
      end
    end
  end
end
