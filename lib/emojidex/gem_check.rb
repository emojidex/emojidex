module Emojidex
  # check the gem exists. (Gemfile or local gem folder)
  class GemCheck
    # from Gemfile
    def self.bundle_install_path(gem_name)
      Gem::Specification.find_by_name(gem_name).full_gem_path
      # Bundler.definition.dependencies.select do |i|
      #   return true if i.name == gem_name
      # end
      # false
    end

    # form local
    def self.install_path(gem_name)
      Gem.find_files(gem_name)
    end
  end
end
