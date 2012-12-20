# Librets-Gem

This is a gem that includes the Librets library for OS X and Heroku.

The following are directions on how to build the binary bundles:

  /lib/librets_native.bundle (OS X Lion)
  /lib/librets_native.so     (Ubuntu 10.04 64-bit)



## Build librets on Mac OS X Lion

Note: Building Librets-Gem is not currently supported on Mountain Lion.

You will need to install the custom homebrew formula in script/homebrw_formula/librets.rb, or maybe
the latest homebrew already has fredngo's patch in it. Check to see if this pull request has been
honored and released -- https://github.com/mxcl/homebrew/pull/13191

Then:

  brew install boost
  brew install swig
  brew install librets

The important artifacts will be located at:
./versions/1.9.3-p194/lib/ruby/site_ruby/1.9.1/librets.rb
./versions/1.9.3-p194/lib/ruby/site_ruby/1.9.1/x86_64-darwin11.3.0/librets_native.bundle

mv the freshly built build/swig/ruby/librets_native.bundle to /lib inside gem
mv project/swig/ruby/librets.rb to /lib inside gem



## Build for Heroku Cedar:

Note the following specs for Heroku Cedar dynos --

  ~ $ arch
  x86_64
  ~ $ cat /etc/issue
  Ubuntu 10.04 LTS \n \l
  ~ $ cat /etc/lsb-release
  DISTRIB_ID=Ubuntu
  DISTRIB_RELEASE=10.04
  DISTRIB_CODENAME=lucid
  DISTRIB_DESCRIPTION="Ubuntu 10.04 LTS"
  ~ $ cat /etc/debian_version
  squeeze/sid
  ~ $ uname -a
  Linux 513cb734-16db-4a04-b6ab-aaf5e9f573ef 2.6.32-343-ec2 #45+lp929941v1 SMP Tue Feb 21 14:07:44 UTC 2012 x86_64 GNU/Linux


To build the librets_native.so binary, we require vulcan 0.8.0 from https://github.com/fredngo/vulcan
or > 0.8.0 from http://github.com/heroku/vulcan (with fredngo's patch). Check to see if this
pull request has been honored and released -- https://github.com/heroku/vulcan/pull/26

Need to have access to the rew-development-support.s3.amazonaws.com/librets-gem S3 bucket --
look how it is used in script/build_librets.rb (search for tarball_server)

Read, and then run the script/build_librets.rb

move the freshly built librets_native.so to /lib inside gem
mv project/swig/ruby/librets.rb to /lib inside gem
