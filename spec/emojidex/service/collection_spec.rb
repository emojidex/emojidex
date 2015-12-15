# encoding: utf-8

require 'spec_helper'

require 'emojidex/service/collection'

describe Emojidex::Service::Collection do
  describe '.initialize' do
    it 'defaults to the emoji index with 50 results per page undetailed' do
      sc = Emojidex::Service::Collection.new
      expect(sc.emoji.count).to eq 50
      expect(sc.detailed).to be false
      expect(sc.endpoint).to eq 'emoji'
      expect(sc.page).to eq 1
      expect(sc.source_path).to be nil
      expect(sc.vector_source_path).to be nil
      expect(sc.raster_source_path).to be nil
    end

    it 'caches, does not re-cache matching assets, re-caches updated assets' do
      clear_tmp_cache
      sc = Emojidex::Service::Collection.new(limit: 2, detailed: true, cache_path: tmp_cache_path)
      sc.cache!
      expect(File.exist?(sc.emoji.values[0].paths[:png][:hdpi])).to be true
      expect(sc.emoji.values[0].checksums[:png][:hdpi]).to eq sc.emoji.values[0].local_checksums[:png][:hdpi]
      File.open(sc.emoji.values[0].paths[:png][:hdpi], 'w') { |f| f.write 'garbagegarbagegarbage' }
      expect(sc.emoji.values[0].checksums[:png][:hdpi]).not_to eq sc.emoji.values[0].generate_local_checksum(:png, :hdpi)
      sc.cache!
      expect(sc.emoji.values[0].checksums[:png][:hdpi]).to eq sc.emoji.values[0].local_checksums[:png][:hdpi]
    end
  end
end
