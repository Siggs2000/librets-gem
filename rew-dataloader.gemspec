# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rew/dataloader/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "librets-gem"
  gem.version       = LibretsGem::VERSION
  gem.authors       = ["Fred Ngo"]
  gem.email         = ["fngo@rew.ca"]
  gem.description   = %q{LibRets RubyGem Wrapper}
  gem.summary       = %q{LibRets RubyGem Wrapper}
  gem.homepage      = "https://github.com/rew-ca/librets-gem"
  gem.files         = ['lib/librets-gem.rb']
  gem.extensions    = ['ext/librets-gem/extconf.rb']
end
