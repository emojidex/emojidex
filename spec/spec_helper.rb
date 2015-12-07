require 'rspec'
require 'emojidex'
require 'emojidex/data/collection'
require 'emojidex/vectors'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def sample_collection(name)
  e = Emojidex::Data::Collection.new
  e.load_local_collection(File.expand_path("../support/sample_collections/#{name}", __FILE__))
  e
end
