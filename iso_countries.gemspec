# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iso_countries/version'

Gem::Specification.new do |gem|
  gem.name          = "iso_countries"
  gem.version       = IsoCountries::VERSION
  gem.authors       = ["sergeych"]
  gem.email         = ["real.sergeych@gmail.com"]
  gem.description   = "Utility class to deal with ISO3166 country codes, names and number"
  gem.summary       = ""
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
end
