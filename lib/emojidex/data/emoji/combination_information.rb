require_relative '../../defaults'

module Emojidex
  module Data
    # Combination information container
    class Combination
      attr_accessor :base, :component_layer_order, :components,
        :checksums, :paths, :remote_checksums

      def initialize(code, combination_info)
        @base = combination_info[:base]

        @components = []
        @components << [Emojidex.escape_code(code.to_s)]
        combination_info[:components].each { |component_set| @components << component_set }
        if combination_info.include? :component_layer_order
          @component_layer_order = combination_info[:component_layer_order]
        else
          @component_layer_order = []
          for i in 0..(@components.length - 1)
            @component_layer_order << i
          end
        end

        @checksums = []
        @paths = []
        @remote_checksums = []
      end
    end

    # Combination information for emoji
    module EmojiCombinationInformation
      attr_accessor :combinations, :customizations,

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

      def add_customization()
        _check_and_init_combinations
        #todo
      end

      private
      def _check_and_init_combinations
        @combinations = [] if @combinations.nil?
        @customizations = [] if @customizations.nil?
      end
    end
  end
end
