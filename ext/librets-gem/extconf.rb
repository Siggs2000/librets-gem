#require 'mkmf'

root = File.expand_path('../../..', __FILE__)

Dir.chdir(File.join(root, 'vendor')) do
  
  software = 'boost_1_49_0'
  #system "bunzip2 #{software}.tar.bz2"
  #system "tar xvf #{software}.tar"
  #Dir.chdir(File.join(root, "vendor/#{software}")) do
  #  args = ["--prefix=#{root}", '--with-libraries=filesystem,program_options']
  #  system './bootstrap.sh', *args
  #  args = ['install', "--prefix=#{root}", 'threading=multi', '--layout=tagged',
  #          '--with-filesystem', '--with-program_options'] 
  #  system './b2', *args
  #  system './b2', '--clean'
  #end
  #system "rm -f #{software}.tar"
  #system "rm -rf #{software}"
  
  # Need SWIG??
  
  software = 'librets-1.5.3'
  #system "bunzip2 #{software}.tar.bz2"
  #system "tar xvf #{software}.tar"
  #Dir.chdir(File.join(root, "vendor/#{software}")) do
  #  args = ['--disable-debug',
  #          '--enable-shared_dependencies',
  #          "--prefix=#{root}",
  #          "--with-boost-prefix=#{root}"
  #          '--disable-dotnet',
  #          '--disable-java',
  #          '--disable-perl',
  #          '--disable-php',
  #          '--disable-python']
  #  system './configure', *args
  #  system 'make'
  #  system 'make install'
  #  system 'make clean'
  #end
  #system "rm -f #{software}.tar"
  #system "rm -rf #{software}"  
end

#create_makefile 'librets-gem'
