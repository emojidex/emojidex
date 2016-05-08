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
      expect(sc.source_path).to eq sc.cache_path
      expect(sc.vector_source_path).to eq sc.cache_path
      expect(sc.raster_source_path).to eq sc.cache_path
    end

    it 'caches, does not re-cache matching assets, re-caches updated assets' do
      clear_tmp_cache
      sc = Emojidex::Service::Collection.new(limit: 2, formats: Emojidex::Defaults.formats,
                                             detailed: true, cache_path: tmp_cache_path)

      sc.cache!(formats: Emojidex::Defaults.formats)
      expect(File.exist?(sc.emoji.values[0].paths[:png][:hdpi])).to be true
      expect(sc.emoji.values[0].remote_checksums[:png][:hdpi]
            ).to eq sc.emoji.values[0].checksums[:png][:hdpi]
      expect(File.exist?(sc.emoji.values[0].paths[:svg])).to be true
      expect(sc.emoji.values[0].remote_checksums[:svg]
            ).to eq sc.emoji.values[0].checksums[:svg]
      File.open(sc.emoji.values[0].paths[:png][:hdpi], 'w'
               ) { |f| f.write 'garbagegarbagegarbage' }
      expect(sc.emoji.values[0].remote_checksums[:png][:hdpi]
            ).not_to eq sc.emoji.values[0].generate_checksum(:png, :hdpi)
      sc.cache!
      expect(sc.emoji.values[0].remote_checksums[:png][:hdpi]
            ).to eq sc.emoji.values[0].checksums[:png][:hdpi]
    end
  end
end
