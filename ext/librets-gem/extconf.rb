require 'mkmf'

root = File.expand_path('../../..', __FILE__)

Dir.chdir(File.join(root, 'vendor/boost_1_49_0.tar.bz2')) do
  system "bunzip2 boost_1_49_0.tar.bz2"
  system "tar xvf boost_1_49_0.tar"
  Dir.chdir() do
    system "./configure", "--prefix=#{root}"
    #system "make"
    #system "make install"
    #system "make clean"
  end
end

#create_makefile 'librets-gem'
