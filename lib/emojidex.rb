require_relative 'emojidex/data/emoji'
require_relative 'emojidex/data/collection'
require_relative 'emojidex/data/category'
require_relative 'emojidex/data/categories'

module Emojidex
  def self.EscapeCode(code)
    code.tr(' ', '_')
  end
end
