
require 'spec_helper'

describe Emojidex::CollectionChecker do

  before(:all) do
   @sizes = [:px32]
  end




  let(:col_good) do
    sample_collection 'good'
  end

  let(:col_missing_assets) do
    sample_collection 'missing_assets'
  end

  let(:col_missing_index) do # just missing entries in index, not missing the actual index
    sample_collection 'missing_index'
  end

  describe 'Spec Collections' do
    it 'load cleanly' do
      expect(col_good).to be_an_instance_of(Emojidex::Collection)
      expect(col_missing_assets).to be_an_instance_of(Emojidex::Collection)
      expect(col_missing_index).to be_an_instance_of(Emojidex::Collection)
    end
  end

  describe '.new' do
    it 'creates a valid CollectionChecker instance and checks a valid collection' do
      checker = Emojidex::CollectionChecker.new(col_good, {sizes: @sizes})

      expect(checker).to be_an_instance_of(Emojidex::CollectionChecker)
      expect(checker.index_only).to be_empty
      expect(checker.asset_only).to be_empty
    end

    it 'checs to see if a size of an asset exists' do
      checker = Emojidex::CollectionChecker.new(col_good, {sizes: [:px64]})

      expect(checker).to be_an_instance_of(Emojidex::CollectionChecker)
      expect(checker.index_only).to eq(4)
      expect(checker.asset_only).to be_empty
    end

    it 'checks for and identifies missing assets' do
      checker = Emojidex::CollectionChecker.new(col_missing_assets, {sizes: @sizes})

      expect(checker.asset_only).to be_empty
      expect(checker.index_only.size).to eq(2)
      expect(checker.index_only).to eq(
        {nut_and_bolt: ["nut_and_bolt.svg"], purple_heart: ["px32/purple_heart.png"]})
    end

    it 'checks for and identifies missing index entries' do
      checker = Emojidex::CollectionChecker.new(col_missing_index, {sizes: @sizes})

      expect(checker.index_only).to be_empty
      expect(checker.asset_only.size).to eq(1)
      expect(checker.asset_only).to eq(
        {purple_heart: ["purple_heart.svg", "px32/purple_heart.png"]})
    end
    it 'checks collections against a specified asset directory' do
      checker = Emojidex::CollectionChecker.new([col_missing_index, col_missing_assets],
                                                {sizes: @sizes, asset_path: col_good.source_path})

      expect(checker.index_only).to be_empty
      expect(checker.asset_only).to be_empty
    end
  end
end
