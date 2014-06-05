# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start

require 'rspec'
require 'webmock/rspec'
require 'emojidex_toolkit'

WebMock.disable_net_connect!(allow_localhost: true)

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

def a_delete(path)
  a_request(:delete, path)
end

def a_get(path)
  a_request(:get, path)
end

def a_post(path)
  a_request(:post, path)
end

def a_put(path)
  a_request(:put, path)
end

def stub_delete(path)
  stub_request(:delete, path)
end

def stub_get(path)
  stub_request(:get, path)
end

def stub_post(path)
  stub_request(:post, path)
end

def stub_put(path)
  stub_request(:put, path)
end

def fixture_path
  File.expand_path('../support/fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
