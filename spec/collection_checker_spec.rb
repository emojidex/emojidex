
require 'spec_helper'

describe Emojidex::CollectionChecker do

  before(:all) do
    @utf_collection = Emojidex::UTF.new
    @extended_collection = Emojidex::Extended.new
    @cache_root_dir = File.expand_path('../support/tmpcache', __FILE__)
    @cache_utf_dir = "#{@cache_root_dir}/utf"
    @cache_extended_dir = "#{@cache_root_dir}/extended"
    @cache_all_dir = "#{@cache_root_dir}/all"
    @source_utf_dir = "#{Emojidex::Vectors.path}/utf"
    @source_extended_dir = "#{Emojidex::Vectors.path}/extended"

    @cache_sizes = [:px32]
    @utf_collection.cache!(cache_dir: @cache_utf_dir, sizes: @cache_sizes)
    @utf_collection.cache!(cache_dir: @cache_all_dir, sizes: @cache_sizes)
    @extended_collection.cache!(cache_dir: @cache_extended_dir, sizes: @cache_sizes)
    @extended_collection.cache!(cache_dir: @cache_all_dir, sizes: @cache_sizes)
  end

  describe 'Checking the UTF collection' do
    it 'verifies the source directory' do
      checker = Emojidex::CollectionChecker.new(
        [@utf_collection],
        @utf_collection.source_path,
        nil,
        [':svg']
      )

      expect(checker.index_only_emoji).to be_empty
      expect(checker.asset_only_emoji).to be_empty
    end

    it 'verifies the asset[cache] directory' do
      checker = Emojidex::CollectionChecker.new(
        [@utf_collection],
        @cache_utf_dir,
        @cache_sizes
      )

      expect(checker.index_only_emoji).to be_empty
      expect(checker.asset_only_emoji).to be_empty
    end
  end

  describe 'Check Extended collection' do
    it 'verifies the source directory' do
      checker = Emojidex::CollectionChecker.new(
        [@extended_collection],
        @source_extended_dir,
        nil,
        [':svg']
      )

      expect(checker.index_only_emoji).to be_empty
      expect(checker.asset_only_emoji).to be_empty
    end

    it 'verifies the asset[cache] directory' do
      checker = Emojidex::CollectionChecker.new(
        [@extended_collection],
        @cache_extended_dir,
        @cache_sizes
      )

      expect(checker.index_only_emoji).to be_empty
      expect(checker.asset_only_emoji).to be_empty
    end
  end

  describe 'Check both UTF and Extended collections together' do
    it 'verifies the cache directory.' do
      checker = Emojidex::CollectionChecker.new(
        [@utf_collection, @extended_collection],
        @cache_all_dir,
        @cache_sizes
      )

      expect(checker.index_only_emoji).to be_empty
      expect(checker.asset_only_emoji).to be_empty
    end
  end

  describe 'Checking when an emoji has been added to the index with no assets' do
    it 'has one instance of index_only_emoji, and no asset_only_emoji' do
      @utf_collection.add_emoji([Emojidex::Emoji.new(
        code: 'hoge',
        code_ja: 'hoge',
        category: 'hoge'
      )])

      checker = Emojidex::CollectionChecker.new(
        [@utf_collection],
        @cache_utf_dir,
        @cache_sizes
      )

      expect(checker.index_only_emoji.size).to eq(1)
      expect(checker.asset_only_emoji).to be_empty
    end
  end

  describe 'Checks for when there are emoji assets that do not exist in the index' do
    it 'has an extra emoji asset without an index entry' do
      File.open("#{@cache_extended_dir}/hoge.svg", 'w').close
      @cache_sizes.each do |size|
        File.open("#{@cache_extended_dir}/#{size}/hoge.png", 'w').close
      end

      checker = Emojidex::CollectionChecker.new(
        [@extended_collection],
        @cache_extended_dir,
        @cache_sizes
      )

      expect(checker.index_only_emoji).to be_empty
      expect(checker.asset_only_emoji.size).to eq(1)
      expect(checker.asset_only_emoji.values[0].size).to eq(@cache_sizes.size + 1)
    end
  end

  after(:all) do
    FileUtils.rm_rf @cache_root_dir
  end
end
