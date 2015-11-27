require 'spec_helper'
require 'emojidex/service/transactor'

describe Emojidex::Service::Transactor do
  describe '.get' do
    it 'gets data' do
      res = Emojidex::Service::Transactor.get('emoji')
      expect(res.count > 0).to be true
    end
  end
end
