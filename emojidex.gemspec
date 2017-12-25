Gem::Specification.new do |s|
  s.name        = 'emojidex'
  s.version     = '0.5.2'
  s.license     = 'emojiOL'
  s.summary     = 'emojidex Ruby tools'
  s.description = 'emojidex emoji handling, search and lookup, listing and caching functionality' \
                  ' and user info (favorites/etc).'
  s.authors     = ['Rei Kagetsuki']
  s.email       = 'info@emojidex.com'
  s.homepage    = 'http://developer.emojidex.com'

  s.required_ruby_version = '>= 2.2.3'
  s.files       = Dir.glob('emoji/**/*') +
                  Dir.glob('lib/**/*.rb') +
                  ['emojidex.gemspec']
  s.require_paths = ['lib']

  s.add_dependency 'faraday', '~> 0.13', '~> 0.13.1'
  s.add_dependency 'faraday_middleware', '~> 0.12', '~> 0.12.2'
  s.add_dependency 'typhoeus', '~> 1.3', '~> 1.3.0'
  s.add_dependency 'msgpack', '~> 1.2'
end
