Gem::Specification.new do |s|
  s.name        = 'emojidex'
  s.version     = '0.0.23'
  s.license     = 'emojiOL'
  s.summary     = 'emojidex Ruby tools'
  s.description = 'emojidex emoji handling, search and lookup, listing and caching functionality' \
                  ' and user info (favorites/etc).'
  s.authors     = ['Rei Kagetsuki']
  s.email       = 'info@emojidex.com'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.homepage    = 'http://developer.emojidex.com'

  s.add_dependency 'faraday', '~> 0.9', '~> 0.9.1'
  s.add_dependency 'faraday_middleware', '~> 0.9', '~> 0.9.1'
end
