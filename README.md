[![Gem Version](https://badge.fury.io/rb/emojidex.png)](http://badge.fury.io/rb/emojidex)
[![Build Status](https://travis-ci.org/emojidex/emojidex.png)](https://travis-ci.org/emojidex/emojidex)
[![Code Climate](https://codeclimate.com/github/emojidex/emojidex.png)](https://codeclimate.com/github/emojidex/emojidex)
[![Coverage Status](https://coveralls.io/repos/emojidex/emojidex/badge.svg?service=github)](https://coveralls.io/github/emojidex/emojidex)
[![Inline docs](http://inch-ci.org/github/emojidex/emojidex.png?branch=master)](http://inch-ci.org/github/emojidex/emojidex)
[![Gitter chat](https://badges.gitter.im/emojidex/emojidex.png)](https://gitter.im/emojidex/emojidex)
emojidex
========
emojidex core tools and scripts in Ruby. Provides a set of tools to utilize emojidex emoji right away in Ruby. Available as the "emojidex" gem.

Usage
=====
The emojidex gem can be used either on-line or off-line. Offline components require you to bundle 
the assets you want to use by including either the emojidex-vectors gem for SVG assets or 
emojidex-rasters gem for PNG assets. Simply including "emojidex-vectors" or "emojidex-rasters" in 
your Gemfile or having the gem installed will enable this. Without one or both of these gems 
installed the off-line components will fall back to connecting to the emojidex service and, if 
they are unable to connect, will attempt to find the assets in the emojidex cache (usually found 
in $HOME/.emojidex).

Off-line
--------
To use emojidex off-line you simply need to make an instance of one or more of the named 
collections in the 'emojidex/data' directory:  
  
For UTF (Unicode Standard) emoji:
```
require 'emojidex/data/utf'

emoji = Emojidex::Data::UTF.new
```

For Extended (emojidex Original) emoji:
```
require 'emojidex/data/extended'

emoji = Emojidex::Data::Extended.new
```

For all emoji in the cache (will include UTF and Extended if they have been cached):
```
require 'emojidex/data/collection'

emoji = Emojidex::Data::Collection.new
```

For a combined set of UTF, Extended and Cached emoji:
```
require 'emojidex/data/collection'
require 'emojidex/data/utf'
require 'emojidex/data/extended'

emoji = Emojidex::Data::Collection.new
emoji << Emojidex::Data::UTF.new
emoji << Emojidex::Data::Extended.new
```


On-line
-------
WIP


Assets
======
You can find Vectors here: [emojidex-vectors](https://github.com/emojidex/emojidex-vectors)  
You can find Rasters here: [emojidex-rasters](https://github.com/emojidex/emojidex-rasters)

License
=======
emojidex and emojidex tools are licensed under the [emojidex Open License](https://www.emojidex.com/emojidex/emojidex_open_license).

©2013 the emojidex project / Genshin Souzou K.K. [Phantom Creation Inc.]
