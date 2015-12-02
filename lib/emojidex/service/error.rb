module Emojidex
  module Service
    module Error
      class Unauthroized < SecurityError; end
      class UnprocessableEntity < StandardError; end

      class InvalidJSON < StandardError; end
    end
  end
end
