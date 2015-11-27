# encoding: utf-8

require 'spec_helper'

require 'emojidex/service/collection'

describe Emojidex::Service::Collection do
  describe '.initialize' do
    it 'defaults to an empty collection' do
      sc = Emojidex::Service::Collection.new
      expect(sc.emoji.count).to eq 0
    end
  end
end
