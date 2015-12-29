require 'spec_helper'
require 'emojidex/client'

describe Emojidex::Client do
  describe 'initialize' do
    it 'defaults to a system cache path' do
      emojidex = Emojidex::Client.new
      expect(emojidex.cache_path).to eq Emojidex::Defaults.system_cache_path
    end

    it 'overrides the cache path with (cache_path: "/path/to/cache")' do
      clear_tmp_cache
      emojidex = Emojidex::Client.new(cache_path: tmp_cache_path)
      expect(emojidex.cache_path).to eq tmp_cache_path
    end

    it 'automatically initializes a user' do
      emojidex = Emojidex::Client.new
      expect(emojidex.user).to be_a(Emojidex::Service::User)
    end

    it 'automatically initializes a collection' do
      emojidex = Emojidex::Client.new
      expect(emojidex.collection).to be_a(Emojidex::Data::Collection)
    end
  end
end
