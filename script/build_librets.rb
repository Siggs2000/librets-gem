#!/usr/bin/env ruby

# Requires vulcan 0.8.0 from https://github.com/fredngo/vulcan

# Vulcan Command Line example
#vulcan build --verbose --source=http://server.fredngo.net/boost_1_49_0.tar.gz --output=/tmp/boost_1_49_0.tar.gz --prefix=/tmp/boost_1_49_0 -c "cd boost_1_49_0 && ./bootstrap.sh --prefix=/tmp/boost_1_49_0 --with-libraries=filesystem,program_options && ./b2 install --prefix=/tmp/boost_1_49_0 threading=multi --layout=tagged --with-filesystem --with-program_options"

########################
# Build a Vulcan Server
########################
VULCAN_SERVER_NAME = 'vulcan-librets'
system "vulcan create #{VULCAN_SERVER_NAME}"
system 'vulcan update'

##################################
# Constants for Building Packages
##################################

tarball_server = 'server.fredngo.net'
prefix = '/tmp/usr/local'

##############
# Build Boost
##############

boost = 'boost_1_49_0'
boost_libs = "#{boost}_libs"

bootstrap_args = ["--prefix=#{prefix}", '--with-libraries=filesystem,program_options'].join(' ')

b2_args = ['install', "--prefix=#{prefix}", 'threading=multi', '--layout=tagged',
           '--with-filesystem', '--with-program_options'].join(' ')

vulcan_args = ['build', '--verbose', "--source=http://#{tarball_server}/#{boost}.tar.gz", "--output=/tmp/#{boost}_libs.tar.gz",
               "--prefix=#{prefix}", "-c", "cd #{boost} && ./bootstrap.sh #{bootstrap_args} && ./b2 #{b2_args}"]
          
system 'vulcan', *vulcan_args


# Integrated pcre into the swig tarball
##### pcre = 'pcre-8.30'
##### pcre_libs = "#{pcre}_libs"

##### configure_args = ["--prefix=#{prefix}"].join(' ')
##### 
##### vulcan_args = ['build', '--verbose', "--source=http://#{tarball_server}/#{pcre}.tar.gz", "--output=/tmp/#{pcre}_libs.tar.gz",
#####                "--prefix=#{prefix}", "-c", "cd #{pcre} && ./configure #{configure_args} && make && make install"]
##### 
##### puts vulcan_args.join(' ')             
##### system 'vulcan', *vulcan_args



#############
# Build SWIG
#############

# Note this swig tarball is customized with a pcre tarball, so that we can run Tools/pcre-build.sh
swig = 'swig-2.0.7-with-pcre-8.30'
swig_libs = "#{swig}_libs"

configure_args = ["--prefix=#{prefix}"].join(' ')

vulcan_args = [
  'build', '--verbose', "--source=http://#{tarball_server}/#{swig}.tar.gz", "--output=/tmp/#{swig}_libs.tar.gz",
  '-d', "#{tarball_server}/#{boost_libs}.tar.gz",
  "--prefix=#{prefix}", "-c", "cd #{swig} && Tools/pcre-build.sh && ./configure #{configure_args} && make && make install"]
          
system 'vulcan', *vulcan_args


################
# Build Librets
################

librets = 'librets-1.5.3'
librets_libs = "#{librets}_libs"

configure_args = [
  "--prefix=#{prefix}", '--with-boost-prefix=$PWD/../../deps', 
  '--enable-shared_dependencies', '--enable-depends',
  '--disable-java', '--disable-perl', '--disable-python'].join(' ')
        
# Have to export SWIG_LIB for compilation to find the previously compiled swig
# Need to insert a prefix with sed into the generated Makefile as the default /usr/local path is not writable on Heroku.
vulcan_args = [
  'build', '--verbose', "--source=http://#{tarball_server}/#{librets}.tar.gz", "--output=/tmp/#{librets}_libs.tar.gz",
  '-d', "#{tarball_server}/#{boost_libs}.tar.gz", "#{tarball_server}/#{swig_libs}.tar.gz",
  "--prefix=#{prefix}", "-c", 
  "export SWIG_LIB=\$PWD/../deps/share/swig/2.0.7 && \
  cd #{librets} && ./configure #{configure_args} && make && \
  mv build/swig/ruby/Makefile build/swig/ruby/Makefile.bak && \
  sed -e 's|prefix = \$(DESTDIR)/usr/local|prefix = #{prefix}|' build/swig/ruby/Makefile.bak > build/swig/ruby/Makefile && \
  make install && \
  mv #{prefix}/lib/ruby/site_ruby/1.9.1/x86_64-linux/librets_native.so #{prefix}/lib && \
  mv #{prefix}/lib/ruby/site_ruby/1.9.1/librets.rb #{prefix}/lib && \
  rm -rf #{prefix}/lib/ruby"]
          
system 'vulcan', *vulcan_args


########################
# Destroy Vulcan server
########################

system "heroku apps:destroy --app #{VULCAN_SERVER_NAME} --confirm #{VULCAN_SERVER_NAME}"