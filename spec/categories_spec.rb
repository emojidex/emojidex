require 'spec_helper'

describe Emojidex::Categories do
  let(:categories) { Emojidex::Categories.new }

  describe '.initialize' do
    it 'initializes a new categories object' do
      expect(categories).to be_an_instance_of(Emojidex::Categories)
    end
  end

  describe '.category' do
    it 'is a proper hash and can be referenced by key' do
      expect(categories.categories[:transportation].en).to eq('Transportation')
    end
  end

end
