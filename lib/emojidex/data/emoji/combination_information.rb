require_relative '../../defaults'
require_relative 'combination'

module Emojidex
  module Data
    # Combination information for emoji
    module EmojiCombinationInformation
      attr_accessor :combinations, :customizations

      def init_combination_info(details)
        _check_and_init_combinations
        fill_combinations(details[:combinations]) if details.include? :combinations
      end

      def fill_combinations(combinations)
        _check_and_init_combinations
        combinations.each do |combination|
          add_combination(combination)
        end
      end

      def add_combination(combination_info)
        _check_and_init_combinations
        @combinations << Combination.new(@code, combination_info) 
      end

      def add_customization(combo)
        _check_and_init_combinations
        added = false
        @customizations.each do |customization|
          if (customization.base == combo.base) &&
              (customization.component_layer_order == combo.component_layer_order)
            for i in 0..(customization.components.length - 1)
              customization.components[i] = customization.components[i] | combo.components[i]
            end
            added = true
          end
        end

        @customizations << combo unless added
      end

      private
      def _check_and_init_combinations
        @combinations = [] if @combinations.nil?
        @customizations = [] if @customizations.nil?
      end
    end
  end
end
