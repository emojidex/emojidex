# encoding: utf-8

require 'spec_helper'

require 'emojidex/service/collection'

describe Emojidex::Service::Collection do
  describe '.initialize' do
    it 'defaults to the emoji index with 50 results per page undetailed' do
      sc = Emojidex::Service::Collection.new
      expect(sc.emoji.count).to eq 50
      expect(sc.detailed).to be false
      expect(sc.endpoint).to eq 'emoji'
      expect(sc.page).to eq 1
    end
  end
end
