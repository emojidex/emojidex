source 'http://rubygems.org'

gemspec

group :development do
  gem 'coveralls', require: false
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'guard'
  gem 'guard-rspec'
  gem 'rubocop'
  gem 'guard-rubocop'
end

group :development, :test do
  #gem 'emojidex-vectors', path: '../emojidex-vectors'
  gem 'emojidex-vectors', github: 'emojidex/emojidex-vectors'
  gem 'simplecov', :require => false
  gem 'rspec'
  gem 'webmock'
end
