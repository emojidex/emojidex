source 'http://rubygems.org'

gemspec

group :development do
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'guard'
  gem 'guard-rspec'
  gem 'rubocop'
  gem 'guard-rubocop'
end

group :development, :test do
  gem 'rspec'
end

group :test do
  gem 'emojidex-vectors', github: 'emojidex/emojidex-vectors'
  #gem 'emojidex-vectors', path: '../emojidex-vectors'
  gem 'emojidex-rasters', github: 'emojidex/emojidex-rasters'
end
