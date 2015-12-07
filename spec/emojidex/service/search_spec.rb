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
      for i in 0..10
        expect(/^face/.match(res.emoji.values[i].code).nil?).to be false
      end
    end
  end

  describe '.ending' do
    it 'searches for a code starting with the term and returns a collection with the results' do
      res = Emojidex::Service::Search.ending('face')
      expect(res).to be_a(Emojidex::Service::Collection)
      expect(res.emoji.count >= 3).to be true
      for i in 0..10
        expect(/face$/.match(res.emoji.values[i].code).nil?).to be false
      end
    end
  end

  describe '.tags' do
    it 'searches for emoji by a single tag' do
      res = Emojidex::Service::Search.tags(:metal)
      expect(res.emoji.values[0].tags.include? :metal).to be true
    end

    it 'searches for emoji by multiple tags and mixed symbols/strings with spaces' do
      res = Emojidex::Service::Search.tags([:metal, 'fist', 'heavy metal'])
      expect(res.emoji.values[0].tags.include? :metal).to be true
      expect(res.emoji.values[0].tags.include? :fist).to be true
    end
  end

  describe '.find' do
  end

  describe '.advanced' do
  end
end
