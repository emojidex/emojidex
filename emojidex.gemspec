Gem::Specification.new do |s|
  s.name        = 'emojidex'
  s.version     = '0.0.6'
  s.license     = 'GPL-3, AGPL-3'
  s.summary     = 'emojidex core, assets and Ruby tools'
  s.description = 'emojidex emoji assets, emoji handling, search and lookup, listing and caching functionality and user info (favorites/etc).'
  s.authors     = ['Rei Kagetsuki', 'Jun Tohyama', 'Vassil Kalkov', 'Rika Yoshida', 'Toshiya Yoshida']
  s.email       = 'zero@genshin.org'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.homepage    = 'http://dev.emojidex.com'

  s.add_dependency 'faraday',             '0.8.9'
  s.add_dependency 'faraday_middleware',  '0.9.0'
end
