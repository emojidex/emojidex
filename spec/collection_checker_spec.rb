
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

  describe 'Check utf collection.' do
    it 'Check source directory.' do
      checker = Emojidex::CollectionChecker.new(
        [@utf_collection],
        @source_utf_dir,
        nil,
        [':svg']
      )

      expect(checker.collection_only_emojis).to be_empty
      expect(checker.cache_only_emojis).to be_empty
    end

    it 'Check cache directory.' do
      checker = Emojidex::CollectionChecker.new(
        [@utf_collection],
        @cache_utf_dir,
        @cache_sizes
      )

      expect(checker.collection_only_emojis).to be_empty
      expect(checker.cache_only_emojis).to be_empty
    end
  end

  describe 'Check extended collection.' do
    it 'Check source directory.' do
      checker = Emojidex::CollectionChecker.new(
        [@extended_collection],
        @source_extended_dir,
        nil,
        [':svg']
      )

      expect(checker.collection_only_emojis).to be_empty
      expect(checker.cache_only_emojis).to be_empty
    end

    it 'Check cache directory.' do
      checker = Emojidex::CollectionChecker.new(
        [@extended_collection],
        @cache_extended_dir,
        @cache_sizes
      )

      expect(checker.collection_only_emojis).to be_empty
      expect(checker.cache_only_emojis).to be_empty
    end
  end

  describe 'Check all collection.' do
    it 'Check cache directory.' do
      checker = Emojidex::CollectionChecker.new(
        [@utf_collection, @extended_collection],
        @cache_all_dir,
        @cache_sizes
      )

      expect(checker.collection_only_emojis).to be_empty
      expect(checker.cache_only_emojis).to be_empty
    end
  end

  describe 'Create illegal case.' do
    it 'Create collection only emoji.' do
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

      expect(checker.collection_only_emojis.size).to eq(1)
      expect(checker.cache_only_emojis).to be_empty
    end

    it 'Create cache only emoji.' do
      File.open("#{@cache_extended_dir}/hoge.svg", 'w').close
      @cache_sizes.each do |size|
        File.open("#{@cache_extended_dir}/#{size}/hoge.png", 'w').close
      end

      checker = Emojidex::CollectionChecker.new(
        [@extended_collection],
        @cache_extended_dir,
        @cache_sizes
      )

      expect(checker.collection_only_emojis).to be_empty
      expect(checker.cache_only_emojis.size).to eq(1)
      expect(checker.cache_only_emojis.values[0].size).to eq(@cache_sizes.size + 1)
    end
  end

  after(:all) do
    FileUtils.rm_rf @cache_root_dir
  end
end
