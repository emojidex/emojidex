# encoding: utf-8

module Emojidex
  # Holds a master list of categories
  class Categories
    attr_accessor :categories

    def initialize(categories_json = nil)
      if categories_json
        load_categories(categories_json)
      else
        load_standard_categories
      end
    end

    def load_categories(json)
      raw = JSON.parse(json, symbolize_names: true)
      raw = raw[:categories]

      @categories ||= {}
      raw.each do |category_info|
        category = Emojidex::Category.new category_info
        @categories[category.code.to_sym] = category
      end
    end

    def load_standard_categories
      load_categories(IO.read(
          File.expand_path('../../../emoji/categories.json', __FILE__)))
    end
  end
end
