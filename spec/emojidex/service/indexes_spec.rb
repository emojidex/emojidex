require 'spec_helper'
require 'emojidex/service/indexes'
require 'emojidex/service/user'
require 'emojidex/defaults'

describe Emojidex::Service::Indexes do
  describe 'emoji' do
    it 'returns a service collection' do
      idx = Emojidex::Service::Indexes.emoji
      expect(idx).to be_a(Emojidex::Service::Collection)
      expect(idx.emoji.count).to eq(Emojidex::Defaults.limit)
      idx.more
      expect(idx.emoji.count).to eq(Emojidex::Defaults.limit * 2)
      expect(idx.source_path).to be nil
      expect(idx.vector_source_path).to be nil
      expect(idx.raster_source_path).to be nil
    end
  end

  describe 'newest' do
    it 'returns a service collection' do
      idx = Emojidex::Service::Indexes.newest()
      expect(idx).to be_a(Emojidex::Service::Collection)
      expect(idx.status).to eq 'resource requires authorization'
      expect(idx.emoji.count == 0).to be true
      
      # attempt to test premium collection
      user = Emojidex::Service::User.new
      user.load
      if user.pro
        idx = Emojidex::Service::Indexes.newest(false, 20, 0, user.username, user.auth_token)
        expect(idx).to be_a(Emojidex::Service::Collection)
        expect(idx.emoji.count == 20).to be true
        expect(idx.more).to be_a(Hash)
        expect(idx.emoji.count == 40).to be true
      else
        puts 'Could not detect a premium user account. Skipping premium collection test.'
      end
      expect(idx.source_path).to be nil
      expect(idx.vector_source_path).to be nil
      expect(idx.raster_source_path).to be nil
    end
  end

  describe 'popular' do
    it 'returns a service collection' do
      idx = Emojidex::Service::Indexes.popular()
      expect(idx).to be_a(Emojidex::Service::Collection)
      expect(idx.status).to eq 'resource requires authorization'
      expect(idx.emoji.count == 0).to be true

      # attempt to test premium collection
      user = Emojidex::Service::User.new
      user.load
      if user.pro
        idx = Emojidex::Service::Indexes.popular(false, 20, 0, user.username, user.auth_token)
        expect(idx).to be_a(Emojidex::Service::Collection)
        expect(idx.emoji.count == 20).to be true
        expect(idx.more).to be_a(Hash)
        expect(idx.emoji.count == 40).to be true
      else
        puts 'Could not detect a premium user account. Skipping premium collection test.'
      end

      expect(idx.source_path).to be nil
      expect(idx.vector_source_path).to be nil
      expect(idx.raster_source_path).to be nil
    end
  end

  describe 'user_emoji' do
    it 'returns a service collection' do
      idx = Emojidex::Service::Indexes.user_emoji('emojidex')
      expect(idx).to be_a(Emojidex::Service::Collection)
      expect(idx.source_path).to be nil
      expect(idx.vector_source_path).to be nil
      expect(idx.raster_source_path).to be nil
    end
  end

  describe 'moji_codes' do
    it 'returns a hash with three different types of standard emoji mappings' do
      codes = Emojidex::Service::Indexes.moji_codes
      expect(codes.key? :moji_string).to be true
      expect(codes[:moji_string].length > 0).to be true
      expect(codes.key? :moji_array).to be true
      expect(codes[:moji_array].length > 0).to be true
      expect(codes.key? :moji_index).to be true
      expect(codes[:moji_index].key? '💩').to be true
      expect(codes[:moji_index]['💩']).to eq 'poop'
    end

    it 'returns emoji mappings in Japanese' do
      codes = Emojidex::Service::Indexes.moji_codes('ja')
      expect(codes.key? :moji_string).to be true
      expect(codes[:moji_string].length > 0).to be true
      expect(codes.key? :moji_array).to be true
      expect(codes[:moji_array].length > 0).to be true
      expect(codes.key? :moji_index).to be true
      expect(codes[:moji_index].key? '💩').to be true
      expect(codes[:moji_index]['💩']).to eq 'うんち'
    end
  end
end
