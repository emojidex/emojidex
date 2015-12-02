require 'spec_helper'
require 'emojidex/service/error'

describe Emojidex::Service::Error do
  describe 'exception classes can be raised and rescued' do
    it 'defines exceptions' do
      expect(Emojidex::Service::Error.constants.length > 0).to be true
    end

    # it 'raises' do
    #   expect(raise Emojidex::Service::Error::Unauthorized).to raise_error(
    #     Emojidex::Service::Error::Unauthorized)
    #   expect(raise Emojidex::Service::Error::UprocessableEntity).to raise_error(
    #     Emojidex::Service::Error::UnprocessableEntity)
    # end
  end
end
