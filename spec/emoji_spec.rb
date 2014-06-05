# encoding: utf-8

require 'spec_helper'

describe Emojidex::Emoji do
  let(:emoji) do
    Emojidex::Emoji.new moji: '🌠', code: 'shooting_star',
                        code_ja: '流れ星', category: 'cosmos',
                        unicode: '1f320', uri: '/dummy/uri'
  end

  describe '.to_s' do
    it 'outputs UTF moji when present' do
      expect(emoji.to_s).to eq('🌠')
    end

    it 'outputs emoji code when UTF is not present' do
      emoji.moji = nil
      expect(emoji.to_s).to eq(':shooting_star:')
    end
  end

  describe '.to_hash' do
    it 'gets a hash containing emoji info' do
      expect(emoji.to_hash).to be_an_instance_of(Hash)
    end
  end

  describe '[]' do
    it 'acts like hash for lookup by key' do
      expect(emoji[:moji]).to eq(emoji.moji)
    end
  end

  describe '[]=' do
    it 'assigns a value in a hash by a key' do
      emoji[:code] = 'star_shot'
      expect(emoji.code).to eq('star_shot')
    end
  end

  describe '.to_json' do
    it 'outputs JSON info from the emoji' do
      expect(JSON.parse(emoji.to_json)).to be_an_instance_of(Hash)
    end
  end

  describe '.frames' do
    it 'holds an array of source frames' do
      expect(emoji.frames).to be_an_instance_of(Array)
    end
  end

  describe '.delays' do
    it 'holds an array of delays between frames' do
      expect(emoji.delays).to be_an_instance_of(Array)
    end

    it 'defaults to 100ms when nothing is specified' do
      expect(emoji.delays[0]).to eq(100)
    end
  end
end
