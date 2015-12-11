require 'rspec'
require 'emojidex'
require 'emojidex/data/collection'
require 'emojidex/vectors'

def sample_collection(name)
  e = Emojidex::Data::Collection.new
  e.load_local_collection(File.expand_path("../support/sample_collections/#{name}", __FILE__))
  e
end

def tmp_cache_path
  File.expand_path('../tmp/samplecache', __FILE__)
end

def clear_tmp_cache
  FileUtils.rm_rf tmp_cache_path if Dir.exist? tmp_cache_path
end
