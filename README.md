# Librets-Gem

This is a gem that includes the Librets library for OS X and Heroku.


## Installation

Add this line to your application's Gemfile:

    gem 'librets-gem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install librets-gem


## Build librets on Mac OS X Lion

You will need to install the custom homebrew formula in script/homebrw_formula/librets.rb, or maybe
the latest homebrew already has fredngo's patch in it. Check to see if this pull request has been
honored -- https://github.com/mxcl/homebrew/pull/13191

Then:

brew install boost
brew install swig
brew install librets

The important artifacts will be located at:
./versions/1.9.3-p194/lib/ruby/site_ruby/1.9.1/librets.rb
./versions/1.9.3-p194/lib/ruby/site_ruby/1.9.1/x86_64-darwin11.3.0/librets_native.bundle

mv build/swig/ruby/librets_native.bundle to /lib inside gem
mv project/swig/ruby/librets.rb to /lib inside gem


## Build for Heroku:

Run script/build_librets.rb

Requires vulcan 0.8.0 from https://github.com/fredngo/vulcan
or > 0.8.0 from http://github.com/heroku/vulcan (with fredngo's patch)

Need to have access to the rew-development-support S3 bucket -- look in script/build_librets.rb

move the built librets_native.so to /lib inside gem
mv project/swig/ruby/librets.rb to /lib inside gem