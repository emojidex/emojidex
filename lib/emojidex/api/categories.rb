module Emojidex
  module API
    # Get cateegories from API
    module Categories
      def categories(*args)
        response = get('/api/v1/categories.json', args)
        response[:body]['categories']
      end

      def category(*args)
        response = get('/api/v1/categories/category.json', args)
        response[:body]
      end
    end
  end
end
