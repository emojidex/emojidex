module Emojidex
  module Data
    # Category information
    class Category
      attr_accessor :code, :en, :ja

      def initialize(details = {})
        @code = details[:code].to_sym
        @en = details[:en]
        @ja = details[:ja]
      end
    end
  end
end
