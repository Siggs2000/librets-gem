require 'mkmf'

root = File.expand_path('../../..', __FILE__)

Dir.chdir(File.join(root, 'vendor')) do
  
  ['boost_1_49_0', 'swig-2.0.7', 'librets-1.5.3'].each do |package|

    #system "bunzip2 -k #{package}.tar.bz2"
    #system "tar xvf #{package}.tar"
#    Dir.chdir(File.join(root, "vendor/#{package}")) do
#      case package
#      when 'boost_1_49_0'    
#      #  args = ["--prefix=#{root}", '--with-libraries=filesystem,program_options']
#      #  system './bootstrap.sh', *args
#      #  args = ['install', "--prefix=#{root}", 'threading=multi', '--layout=tagged',
#      #          '--with-filesystem', '--with-program_options'] 
#      #  system './b2', *args
#      #  system './b2', '--clean'
#      
#      when 'swig-2.0.7'
#      #  system 'mv ../pcre-8.30.tar.gz .'
#      #  system 'Tools/pcre-build.sh'
#      #  args = ["--prefix=#{root}", "--with-boost=#{root}"] #, "--with-pcre-prefix=#{root}", "--with-pcre-exec-prefix=#{root}/bin"]
#      #  system './configure', *args
#      #  system 'make'
#      #  system 'make install'
#      #  system 'make clean'
#     
#      when 'librets-1.5.3'
#      #system "PATH=$PATH:#{root}/bin; export PATH"
#      #  args = ["--prefix=#{root}",
#      #          "--with-boost-prefix=#{root}",
#      #          '--enable-shared_dependencies', '--enable-depends'
#      #          '--disable-java', '--disable-perl', '--disable-python']
#      #  system './configure', *args
#      #  system 'make'
#      
#      #  system "sed -e 's|prefix = \$(DESTDIR)/usr/local|prefix = #{root}|' Makefile > Makefile"
#
#      #  system 'make install'
#      #  system "mv #{root}/lib/ruby/site_ruby/1.9.1/x86_64-linux/librets_native.so #{root}/lib"
#      #  system "mv #{root}/lib/ruby/site_ruby/1.9.1/librets.rb #{root}/lib"
#      #  system "rm -rf #{root}/lib/ruby"
#
#      #  system 'make clean'
#
#
#      end
#
#    end
    #system "rm -f #{package}.tar"
    #system "rm -rf #{package}" 
    
  end
end

create_makefile 'librets-gem'
