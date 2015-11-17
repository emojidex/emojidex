require 'spec_helper'

describe Emojidex::Data::Categories do
  let(:categories) { Emojidex::Data::Categories.new }

  describe '.initialize' do
    it 'initializes a new categories object' do
      expect(categories).to be_an_instance_of(Emojidex::Data::Categories)
    end
  end

  describe '.category' do
    it 'is a proper hash and can be referenced by key' do
      expect(categories.categories[:transportation].en).to eq('Transportation')
      expect(categories.categories[:transportation].ja).to eq('乗り物')
    end
  end

end
