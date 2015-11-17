[![Gem Version](https://badge.fury.io/rb/emojidex.png)](http://badge.fury.io/rb/emojidex)
[![Build Status](https://travis-ci.org/emojidex/emojidex.png)](https://travis-ci.org/emojidex/emojidex)
[![Code Climate](https://codeclimate.com/github/emojidex/emojidex.png)](https://codeclimate.com/github/emojidex/emojidex)
[![Coverage Status](https://coveralls.io/repos/emojidex/emojidex/badge.svg?service=github)](https://coveralls.io/github/emojidex/emojidex)
[![Inline docs](http://inch-ci.org/github/emojidex/emojidex.png?branch=master)](http://inch-ci.org/github/emojidex/emojidex)
[![Gitter chat](https://badges.gitter.im/emojidex/emojidex.png)](https://gitter.im/emojidex/emojidex)
emojidex
========
emojidex core tools and scripts in Ruby. Provides a set of tools to utilize emojidex emoji right away in Ruby. Available as the "emojidex" gem.

Assets
======
You can find Vectors here: [emojidex-vectors](https://github.com/emojidex/emojidex-vectors)  
You can find Rasters here: [emojidex-rasters](https://github.com/emojidex/emojidex-rasters)

Notes / Caution
===============

Pre 1.8 or non 1.9+ compliant Ruby
----------------------------------
emojidex uses a variety of tricks and extensively utilizes UTF8/Unicode in ways most other code does not. As such, we do not recommend attempting 
to run emojidex on non 1.9+ compliant Ruby variants, and instead recommend the latest official Ruby. If you are/must use a non 1.9+ official Ruby 
and find an issue that can be remedied without imparing functionality or significantly impacting performance please notify us with an issue or 
submit a pull request with a patch.

jRuby
-----
From 1.9 on Ruby is an m17n compliant Code Set Independent languge. jRuby, however, does not fulfill this requirement and has a variety of issues 
dealing with UTF8 code -and- content. It should be noted that this is NOT so much a fault of jRuby as it is the JRE/JVM, which simply imposes a 
code set (which in many/most cases is NOT UTF8) on jRuby. Due to this, caution must be excercised when using jRuby. You must make absolutely sure 
that the Java environment you are using is being run with UTF8 as the code set.

License
=======
emojidex and emojidex tools are licensed under the [emojidex Open License](https://www.emojidex.com/emojidex/emojidex_open_license).

©2013 the emojidex project / Genshin Souzou K.K. [Phantom Creation Inc.]
