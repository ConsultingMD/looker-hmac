# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grnds/looker/hmac/version'

Gem::Specification.new do |spec|
  spec.name          = "grnds-looker-hmac"
  spec.version       = Grnds::Looker::Hmac::VERSION
  spec.authors       = ["Bradley Johnson"]
  spec.email         = ["brad@grio.com"]
  spec.date          = %q{2014-08-22}
  spec.summary       = %q{Generates looker signed urls}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
