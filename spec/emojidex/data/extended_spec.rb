# encoding: utf-8

require 'spec_helper'

describe Emojidex::Data::Extended do
  let(:ext) { Emojidex::Data::Extended.new }

  describe '.each' do
    it 'provides each emoji' do
      ext.each do |emoji|
        expect(emoji).to be_an_instance_of(Emojidex::Data::Emoji)
      end
    end
  end

  describe 'find_by_code' do
    it 'finds and returns an emoji by code' do
      expect(ext.find_by_code('combat_knife'))
      .to be_an_instance_of(Emojidex::Data::Emoji)
    end

    it 'finds and returns an emoji by code, converting spaces to underscores' do
      expect(ext.find_by_code('combat knife'))
      .to be_an_instance_of(Emojidex::Data::Emoji)
    end

    it 'returns nil when a code does not exist' do
      expect(ext.find_by_code('super_fantastic')).to be_nil
    end
  end

  describe 'find_by_code_ja' do
    it 'finds and returns an emoji by Japanese code' do
      expect(ext.find_by_code_ja('忍者'))
        .to be_an_instance_of(Emojidex::Data::Emoji)
    end
  end

  describe 'コード検索' do
    it 'find_by_code_jaをaliasして日本語の絵文字コードで検索する' do
      expect(ext.コード検索('忍者')).to be_an_instance_of(Emojidex::Data::Emoji)
    end
  end

  describe 'category' do
    it 'returns a collection of the specificed category' do
      expect(categorized = ext.category(:tools)).to be_an_instance_of(Emojidex::Data::Collection)
      expect(categorized.emoji.count).to be > 1
    end
  end

  describe 'category?' do
    it 'returns true when collection contains emoji in that category' do
      expect(ext.category?(:tools)).to be true
    end

    it 'returns false when collection does not contain emoji in that category' do
      expect(ext.category?(:this_is_a_fake_category_do_not_use)).to be false
    end

    it 'returns true when collection contains emoji in multple categories' do
      expect(ext.category?(:tools, :abstract)).to be true
    end

    it 'returns false when collection does not contain emoji in one or more categories' do
      expect(ext.category?(:tools, :this_is_a_fake_category_do_not_use)).to be false
    end
  end

  describe 'categories' do
    it 'is an array of categories which contain emoji in this collection' do
      expect(ext.categories).to be_an_instance_of(Array)
      expect(ext.categories.length).to be > 1
    end
  end

  describe 'emoji.tags' do
    it 'some emoji should have tags' do
      expect(ext.emoji[:assault_rifle].tags.length).to be > 1
    end

    it 'tags should be an array of symbols' do
      expect(ext.emoji[:assault_rifle].tags.include? :weapon).to be true
    end
  end

  describe 'search' do
    it 'searches for an emoji with a set of options' do
      expect(ext.search(code: 'apple', category: 'abstract').emoji.count).to be >= 1
    end

    it 'searches, returning an empty collection when none are found' do
      expect(ext.search(code: 'fake_emoji', category: 'abstract').emoji.count).to be == 0
      expect(ext.search(code: 'apple', category: 'fake_category').emoji.count).to be == 0
    end

    it 'returns all emoji containing the search term as a substring' do
      expect(ext.search(code: 'square', category: 'symbols').emoji.count).to be > 12
    end

    it 'evaluates regular expressions' do
      col = ext.search(code: 'emoji(?!.*dex$).*', category: 'symbols')
      expect(col.find_by_code('emoji')).to be_an_instance_of Emojidex::Data::Emoji
      expect(col.find_by_code('emojidex')).to be_nil
    end
  end
end
