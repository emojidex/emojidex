[![Gem Version](https://badge.fury.io/rb/emojidex.png)](http://badge.fury.io/rb/emojidex)
[![Build Status](https://travis-ci.org/emojidex/emojidex.png)](https://travis-ci.org/emojidex/emojidex)
[![Code Climate](https://codeclimate.com/github/emojidex/emojidex.png)](https://codeclimate.com/github/emojidex/emojidex)
[![Coverage Status](https://coveralls.io/repos/emojidex/emojidex/badge.svg?service=github)](https://coveralls.io/github/emojidex/emojidex)
[![Inline docs](http://inch-ci.org/github/emojidex/emojidex.png?branch=master)](http://inch-ci.org/github/emojidex/emojidex)
[![Gitter chat](https://badges.gitter.im/emojidex/emojidex.png)](https://gitter.im/emojidex/emojidex)

emojidex
========
emojidex core tools and scripts in Ruby. Provides a set of tools to utilize emojidex emoji right 
away in Ruby. Available as the "emojidex" gem.

Usage
=====
The emojidex gem can be used either on-line or off-line. Offline components require you to bundle 
the assets you want to use by including either the emojidex-vectors gem for SVG assets or 
emojidex-rasters gem for PNG assets. Simply including "emojidex-vectors" or "emojidex-rasters" in 
your Gemfile or having the gem installed will enable this. Without one or both of these gems 
installed the off-line components will fall back to connecting to the emojidex service and, if 
they are unable to connect, will attempt to find the assets in the emojidex cache (usually found 
in $HOME/.emojidex).

emojidex isn't just a set of emoji and some tools, it's a full service that allows anyone to 
register their own emoji and for anyone else to use them. emojidex can also store a users 
favorites and history.

emojidex Client
---------------
The emojidex Client attempts to make using emojidex for an end-user application as simple as 
possible. There is no need to manually cache or join collections or separately instantiate a 
user as these are all done for you. A client will automatically try to load user details and 
a primary emoji cache from ```$HOME/.emojidex``` unless overridden by the EMOJI_CACHE 
environment variable or by instantiating a client with the cache_path option like
```emojidex = Emojidex::Client.new(cache_path: "/path/to/cache")```.

emoji Collections
-----------------
The Collection is the primary container for sets of emoji. All containers inherit from 
Emojidex::Data::Collection.

emoji
-----
the Emojidex::Data::Emoji object contains the details of a single emoji.

```ruby
emoji.path(:png, :hdpi)
```

emoji Indexes
-------------


Off-line Usage
==============
When using emojidex off-line you will only have access to the collections you have included or 
have available locally. Two collections are available as gems, the emojidex-rasters gem contains 
PNG in various sizes and the emojidex-vectors gem contains SVG assets. Both contain the UTF and 
Extended collections. To use either of them you simply need to make an instance of one or more 
of the named collections in 'emojidex/data' after requiring either 'emojidex-rasters' or 
'emojidex-vectors. We'll use the more-commonly used PNG rasters for this example: 
  
For UTF (Unicode Standard) emoji:
```
require 'emojidex-rasters'
require 'emojidex/data/utf'

emoji = Emojidex::Data::UTF.new
```

For Extended (emojidex Original) emoji:
```
require 'emojidex-rasters'
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

*Warning*  
Off-line usage is limited to open-source projects. If you are using this gem without 
connecting to the emojidex service and your project is not open-source a commercial license 
is required. Please contact info at emojidex dot com for details.

Assets
======
You can find Vectors here: [emojidex-vectors](https://github.com/emojidex/emojidex-vectors)  
You can find Rasters here: [emojidex-rasters](https://github.com/emojidex/emojidex-rasters)

License
=======
emojidex and emojidex tools are licensed under the 
[emojidex Open License](https://www.emojidex.com/emojidex/emojidex_open_license).

©2013 the emojidex project / K.K. GenSouSha [Phantom Creation Inc.]
