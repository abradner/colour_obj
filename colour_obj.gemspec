# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'colour_obj/version'

Gem::Specification.new do |spec|
  spec.name          = "colour_obj"
  spec.version       = ColourObj::VERSION
  spec.authors       = ["Alex Bradner"]
  spec.email         = ["alex@bradner.net"]
  spec.description   = "RGB int and hex colour library"
  spec.summary       = "Handles parsing and manipulation of 24bpp RGB colour values"
  spec.homepage      = "http://github.com/abradner/colour_obj"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"

  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-rcov"
  spec.add_development_dependency "json"
  spec.add_development_dependency "rake"

end
