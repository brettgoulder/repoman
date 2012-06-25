# -*- encoding: utf-8 -*-
require File.expand_path('../lib/repoman/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brett Goulder"]
  gem.email         = ["brett.goulder@gmail.com"]
  gem.description   = %q{Repoman - A Git history visualization}
  gem.summary       = %q{Repoman - A Git history visualization}
  gem.homepage      = "https://www.github.com/brettgoulder/repoman"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "repoman"
  gem.require_paths = ["lib"]
  gem.version       = Repoman::VERSION
  gem.default_executable = 'repoman'

  gem.add_dependency "grit"
  gem.add_dependency "map"
  gem.add_dependency "sinatra"
  gem.add_dependency "rugged", "0.17.0b2"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "jasmine"
end
