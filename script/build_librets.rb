#!/usr/bin/env ruby

# Requires vulcan 0.8.0 from https://github.com/fredngo/vulcan 
# or 0.8.1 from http://github.com/heroku/vulcan

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
output_dir = '/tmp'

##############
# Build Boost
##############

boost = 'boost_1_49_0'
boost_libs = "#{boost}_libs"

bootstrap_args = ["--prefix=#{prefix}", '--with-libraries=filesystem,program_options'].join(' ')

b2_args = ['install', "cxxflags=-fPIC", "--prefix=#{prefix}", 'threading=multi', 'link=static', 'runtime-link=static', 
           '--layout=tagged', '--with-filesystem', '--with-program_options'].join(' ')

vulcan_args = ['build', '--verbose', "--source=http://#{tarball_server}/#{boost}.tar.gz", "--output=#{output_dir}/#{boost}_libs.tar.gz",
               "--prefix=#{prefix}", "-c", "cd #{boost} && ./bootstrap.sh #{bootstrap_args} && ./b2 #{b2_args}"]
          
system 'vulcan', *vulcan_args
puts "*********************************************************************************************"
puts "Now upload #{output_dir}/#{boost_libs}.tar.gz to http://#{tarball_server}/#{boost_libs}.tar.gz"
puts "Press ENTER to continue..."
puts "*********************************************************************************************"
gets

##############
# Build Expat
##############

expat = 'expat-2.1.0'
expat_libs = "#{expat}_libs"

configure_args = ['LDFLAGS=-static', '--with-pic', "--prefix=#{prefix}"].join(' ')

vulcan_args = [
  'build', '--verbose', "--source=http://#{tarball_server}/#{expat}.tar.gz", "--output=#{output_dir}/#{expat}_libs.tar.gz",
  "--prefix=#{prefix}", "-c", "cd #{expat} && \
   export CXX_FLAGS=-fPIC && export CFLAGS=-fPIC &&\
   ./configure #{configure_args} && make LDFLAGS=-all-static && make install"]
          
system 'vulcan', *vulcan_args
puts "*********************************************************************************************"
puts "Now upload #{output_dir}/#{expat_libs}.tar.gz to http://#{tarball_server}/#{expat_libs}.tar.gz"
puts "Press ENTER to continue..."
puts "*********************************************************************************************"
gets

#############
# Build SWIG
#############

# Note this swig tarball is customized with a pcre tarball, so that we can run Tools/pcre-build.sh
swig = 'swig-2.0.7-with-pcre-8.30'
swig_libs = "#{swig}_libs"

configure_args = ['LDFLAGS=-static', "--prefix=#{prefix}"].join(' ')

vulcan_args = [
  'build', '--verbose', "--source=http://#{tarball_server}/#{swig}.tar.gz", "--output=#{output_dir}/#{swig}_libs.tar.gz",
  '-d', "#{tarball_server}/#{boost_libs}.tar.gz",
  "--prefix=#{prefix}", "-c", "cd #{swig} && Tools/pcre-build.sh && \
   ./configure #{configure_args} && make LDFLAGS=-all-static && make install"]
          
system 'vulcan', *vulcan_args
puts "*********************************************************************************************"
puts "Now upload #{output_dir}/#{swig_libs}.tar.gz to http://#{tarball_server}/#{swig_libs}.tar.gz"
puts "Press ENTER to continue..."
puts "*********************************************************************************************"
gets

################
# Build Librets
################

librets = 'librets-1.5.3'
librets_libs = "#{librets}_libs"

configure_args = ['LDFLAGS=-static', 
  "--prefix=#{prefix}",
  '--with-boost-prefix=$PWD/../../deps', 
  '--with-expat-prefix=$PWD/../../deps',
  '--enable-depends',
  '--disable-java', '--disable-perl', '--disable-python'].join(' ')
        
# Have to export SWIG_LIB for compilation to find the previously compiled swig
# Need to insert a prefix with sed into the generated Makefile as the default /usr/local path is not writable on Heroku.
vulcan_args = [
  'build', '--verbose', "--source=http://#{tarball_server}/#{librets}.tar.gz", "--output=#{output_dir}/#{librets}_libs.tar.gz",
  '-d', "#{tarball_server}/#{boost_libs}.tar.gz", "#{tarball_server}/#{swig_libs}.tar.gz", "#{tarball_server}/#{expat_libs}.tar.gz",
  "--prefix=#{prefix}", "-c", 
  "export SWIG_LIB=\$PWD/../deps/share/swig/2.0.7 && \
  ln -s \$PWD/../deps/lib/libboost_program_options-mt-s.a \$PWD/../deps/lib/libboost_program_options.a && \ 
  ln -s \$PWD/../deps/lib/libboost_filesystem-mt-s.a \$PWD/../deps/lib/libboost_filesystem.a && \
  ln -s \$PWD/../deps/lib/libboost_system-mt-s.a \$PWD/../deps/lib/libboost_system.a && \
  cd #{librets} && \
  mv project/build/ruby.mk project/build/ruby.mk.bak && \
  sed -e 's|LDFLAGS=|CFLAGS=\"-I../../../project/librets/include \${CFLAGS}\" LDFLAGS=|' project/build/ruby.mk.bak > project/build/ruby.mk && \
  rm project/build/ruby.mk.bak && \
  mv project/swig/ruby/extconf.rb project/swig/ruby/extconf.rb.bak && \
  sed -e 's|Makefile\")|Makefile\"); orig_makefile.gsub!(/-shared/, \"-shared -fPIC\").gsub!(/-rdynamic -Wl,-export-dynamic/, \"\"); puts orig_makefile |' project/swig/ruby/extconf.rb.bak > project/swig/ruby/extconf.rb && \
  rm project/swig/ruby/extconf.rb.bak && \
  ./configure #{configure_args} && \
  make LDFLAGS=-all-static && \
  mv build/swig/ruby/Makefile build/swig/ruby/Makefile.bak && \
  sed -e 's|prefix = \$(DESTDIR)/usr/local|prefix = #{prefix}|' build/swig/ruby/Makefile.bak > build/swig/ruby/Makefile && \
  export LDFLAGS=-all-static && \
  make install && \
  mv #{prefix}/lib/ruby/site_ruby/1.9.1/x86_64-linux/librets_native.so #{prefix}/lib && \
  mv #{prefix}/lib/ruby/site_ruby/1.9.1/librets.rb #{prefix}/lib && \
  rm -rf #{prefix}/lib/ruby"]
     
system 'vulcan', *vulcan_args
puts "*********************************************************************************************"
puts "Now upload #{output_dir}/#{librets_libs}.tar.gz to http://#{tarball_server}/#{librets_libs}.tar.gz"
puts "Press ENTER to continue..."
puts "*********************************************************************************************"
gets

########################
# Destroy Vulcan server
########################

system "heroku apps:destroy --app #{VULCAN_SERVER_NAME} --confirm #{VULCAN_SERVER_NAME}"