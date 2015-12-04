require 'rspec'
require 'emojidex'
require 'emojidex/data/collection'
require 'emojidex/vectors'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'

  if ENV['TRAVIS']
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end

  SimpleCov.start do
    add_filter '/spec/'
  end
end

def sample_collection(name)
  e = Emojidex::Data::Collection.new
  e.load_local_collection(File.expand_path("../support/sample_collections/#{name}", __FILE__))
  e
end
