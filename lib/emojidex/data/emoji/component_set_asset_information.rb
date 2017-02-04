require 'digest/md5'
require_relative '../../defaults'

module Emojidex
  module Data
    # Asset information for emoji
    module EmojiComponentSetAssetInformation
      attr_accessor :checksums, :paths, :remote_checksums

      def init_asset_info(details = {})
        blank_paths
        blank_checksums
        fill_remote_checksums(details[:checksums]) if details.include? :checksums
      end

      def generate_blank_entry_set
        entry_set = []
        @components.each do |component_set|
          component_group = {}
          component_set.each do |single_component|
            next if single_component == ''
            component_group[single_component] = {}
            component_group[single_component][:svg] = nil
            component_group[single_component][:png] = {}
            Emojidex::Defaults.sizes.keys.each do |size|
              component_group[single_component][:png][size] = nil
            end
          end
          entry_set << component_group
        end
        entry_set
      end

      def blank_paths
        @paths = generate_blank_path_set
      end

      def generate_blank_path_set
        paths = {}
        paths[:svg] = nil
        paths[:png] = {}
        Emojidex::Defaults.sizes.keys.each do |size|
          paths[:png][size] = nil
        end
        paths
      end

      def fill_paths(paths)
        @paths = paths
        @paths[:svg].slice!(/\.svg$/)
        @paths[:png].each { |png| png.slice!(/\.png$/) }
      end

      def blank_checksums
        @checksums = generate_blank_entry_set
        @remote_checksums = generate_blank_entry_set
      end

      def generate_checksum(component_set_num, component_name, format, size = nil)
        case format
        when :png
          return @checksums[component_set_num][component_name][:png][size] =
            _checksum_for_file("#{@paths[:png][size]}/#{component_set_num}/#{component_name}.png")
        when :svg
          return @checksums[component_set_num][component_name][:svg] =
            _checksum_for_file("#{@paths[:svg]}/#{component_set_num}/#{component_name}.svg")
        end
        nil
      end

      def generate_checksums
        @components.each_with_index do |component_set, i|
          component_set.each do |component_name|
            generate_checksum(i, component_name, :svg)
            @checksums[i][component_name][:png].keys.each do |size_key|
              generate_checksum(i, component_name, :png, size_key)
            end
          end
        end
      end

      def fill_remote_checksums(checksums)
        #todo once implemented in API
      end

      private

      def _checksum_for_file(path)
        (File.exist? path) ? Digest::MD5.file(path).hexdigest : nil
      end
    end
  end
end
