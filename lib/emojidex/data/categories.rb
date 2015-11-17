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

    # each override to map each functionality to the categories hash
    def each(&block)
      @categories.values.each(&block)
    end

    # select override to map select functionality to the categories hash
    def select(&block)
      @categories.values.select(&block)
    end

    # map override to map each functionality to the categories hash
    def map(&block)
      @categories.values.map(&block)
    end

    # collect override to map each functionality to the categories hash
    def collect(&block)
      @categories.values.collect(&block)
    end

    # loads categories from a JSON hash object / JSON text
    def load_categories(json)
      raw = JSON.parse(json, symbolize_names: true)
      raw = raw[:categories]

      @categories ||= {}
      raw.each do |category_info|
        category = Emojidex::Category.new category_info
        @categories[category.code.to_sym] = category
      end
    end

    # loads standard categories local to the emojidex package
    # *automatically called on initialize if no options are passed
    def load_standard_categories
      load_categories(IO.read(File.expand_path('../../../../emoji/categories.json', __FILE__)))
    end
  end
end
