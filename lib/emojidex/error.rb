module Emojidex
  # emojidex error class
  class Error < StandardError
    attr_reader :wrapped_exception

    def initialize(exception = $ERROR_INFO)
      @wrapped_exception = exception
      if exception.respond_to?(:message)
        super(exception.message)
      else
        super(exception.to_s)
      end
    end
  end
end
