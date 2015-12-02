module Emojidex
  module Service
    module Error
      class Unauthorized < SecurityError; end
      class UnprocessableEntity < StandardError; end
      class InvalidJSON < StandardError; end
    end
  end
end
