require 'spec_helper'
require 'emojidex/service/search'

describe Emojidex::Service::Search do
  describe '.term' do
    it 'searches for a term and returns a collection with the results' do
      res = Emojidex::Service::Search.term('chocolate')
      expect(res).to be_a(Emojidex::Service::Collection)
      expect(res.emoji.count >= 3).to be true
    end
  end

  describe '.search' do
    it 'searches for a term and returns a collection with the results' do
      res = Emojidex::Service::Search.term('チョコ')
      expect(res).to be_a(Emojidex::Service::Collection)
      expect(res.emoji.count >= 3).to be true
    end
  end

  describe '.starting' do
    it 'searches for a code starting with the term and returns a collection with the results' do
      res = Emojidex::Service::Search.starting('face')
      expect(res).to be_a(Emojidex::Service::Collection)
      expect(res.emoji.count >= 3).to be true
      puts "#{res.emoji.values[0].code}"
      expect(res.emoji.values[0].code.match('^face')).to be true
    end
  end

  describe '.ending' do
  end

  describe '.tags' do
  end

  describe '.find' do
  end

  describe '.advanced' do
  end
end
