require_relative 'emojidex/defaults'
require_relative 'emojidex/data/emoji'
require_relative 'emojidex/data/collection_checker'
require_relative 'emojidex/data/collection'
require_relative 'emojidex/data/category'
require_relative 'emojidex/data/categories'

# Master emojidex module. Contains a few general helper functions.
module Emojidex
  def self.escape_code(code)
    code.tr(' ', '_').tr(':', '')
  end

  def self.unescape_code(code)
    code.tr('_', ' ')
  end

  def self.encapsulate_code(code)
    "#{Emojidex::Defaults.encapsulator}#{unescape_code(code)}#{Emojidex::Defaults.encapsulator}"
  end
end
