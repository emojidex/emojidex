# encoding: utf-8

require 'spec_helper'

describe Emojidex::Collection do
  let(:collection) { Emojidex::Collection.new(nil, './spec/support/sample_collections/good') }

  describe '.load_local_collection' do
    it 'loads a local collection' do
      expect(collection).to be_an_instance_of(Emojidex::Collection)
    end
  end

  describe '.each' do
    it 'provides each emoji' do
      collection.each do |emoji|
        expect(emoji).to be_an_instance_of(Emojidex::Emoji)
      end
    end
  end

  describe '.find_by_moji' do
    it 'finds and returns an emoji object by UTF moji code' do
      expect(collection.find_by_moji('👯')).to be_an_instance_of(Emojidex::Emoji)
    end

    it 'returns nil when the moji code does not exist' do
      expect(collection.find_by_moji('XX')).to be_nil
    end
  end

  describe '.文字検索' do
    it 'find_by_moji_codeをaliasして文字コードで検索する' do
      expect(collection.文字検索('👯')).to be_an_instance_of(Emojidex::Emoji)
    end
  end

  describe '.find_by_code' do
    it 'finds and returns an emoji by code' do
      ss = collection.find_by_code('nut_and_bolt')
      expect(ss).to be_an_instance_of(Emojidex::Emoji)
    end

    it 'returns nil when a code does not exist' do
      expect(collection.find_by_code('super_fantastic')).to be_nil
    end
  end

  describe '.find_by_code_ja' do
    it 'finds and returns an emoji by Japanese code' do
      expect(collection.find_by_code_ja('ハート(紫)')).to be_an_instance_of(Emojidex::Emoji)
    end
  end

  describe '.コード検索' do
    it 'find_by_code_jaをaliasして日本語の絵文字コードで検索する' do
      expect(collection.コード検索('ハート(紫)')).to be_an_instance_of(Emojidex::Emoji)
    end
  end

  describe '.cache!' do
    it 'caches emoji to local storage cache' do
      tmp_cache_path = File.expand_path('../support/tmpcache', __FILE__)
      collection.cache!(cache_path: tmp_cache_path)
      expect(ENV['EMOJI_CACHE']).to eq(collection.cache_path)
      expect(File.exist? tmp_cache_path).to be_truthy
      expect(File.exist? tmp_cache_path + '/mouth.svg').to be_truthy
      expect(File.exist? tmp_cache_path + '/emoji.json').to be_truthy

      FileUtils.rm_rf tmp_cache_path # cleanup
    end
  end

  describe '.cache_index' do
    it 'caches the  index to the specified location' do
      tmp_cache_path = File.expand_path('../support/tmpcache', __FILE__)
      FileUtils.mkdir_p(tmp_cache_path)
      collection.cache_index tmp_cache_path
      expect(File.exist? tmp_cache_path + '/emoji.json').to be_truthy

      FileUtils.rm_rf tmp_cache_path
    end
  end

  describe '.write_index' do
    it 'writes a cleaned index to the specified location' do
      tmp_cache_path = File.expand_path('../support/tmpcache', __FILE__)
      FileUtils.mkdir_p(tmp_cache_path)
      collection.cache_index tmp_cache_path
      expect(File.exist? tmp_cache_path + '/emoji.json').to be_truthy

      FileUtils.rm_rf tmp_cache_path
    end
  end

  describe '.generate_checksums' do
    it 'generates checksums for assets' do
      expect(collection.generate_checksums).to be_an_instance_of(Array)
      expect(collection.emoji.values.first.checksums[:svg]).to be_truthy
      expect(collection.emoji.values.first.checksum?(:svg)).to be_truthy
      expect(collection.emoji.values.first.checksums[:png][:px32]).to be_truthy
      expect(collection.emoji.values.first.checksum?(:png, :px32)).to be_truthy
      expect(collection.emoji.values.first.checksums[:png][:px64]).to be_nil
      expect(collection.emoji.values.first.checksum?(:png, :px64)).to be_nil
    end
  end

  describe '.generate_paths' do
    it 'generates file paths for each emoji' do
      expect(collection.generate_paths).to be_an_instance_of(Array)
      expect(collection.emoji.values.first.paths[:svg]).to be_truthy
      expect(collection.emoji.values.first.path?(:svg)).to be_truthy
      expect(collection.emoji.values.first.paths[:png][:px32]).to be_truthy
      expect(collection.emoji.values.first.path?(:png, :px32)).to be_truthy
      expect(collection.emoji.values.first.paths[:png][:px64]).to be_nil
      expect(collection.emoji.values.first.path?(:png, :px64)).to be_nil
    end
  end
end
