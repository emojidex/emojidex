require_relative 'component_set_asset_information.rb'

module Emojidex
  module Data
    # Combination information container
    class ComponentSet
      # * base: the named base that this combination belongs to
      # * combinations: combinations starting with this emoji; base/components/component order
      # * cutomizations: emoji which start customization of this emoji (this is combination base)
      attr_accessor :base, :component_layer_order, :components

      include Emojidex::Data::EmojiComponentSetAssetInformation

      def initialize(code, combination_info, details = {})
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

        init_asset_info(details)
      end

      def to_json(options = {})
        {
          base: @base,
          component_layer_order: @component_layer_order,
          components: @components,
          checksums: @checksums
        }.to_json
      end
    end
  end
end
