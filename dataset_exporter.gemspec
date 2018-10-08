# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dataset_exporter/version'

Gem::Specification.new do |spec|
  spec.name          = "dataset_exporter"
  spec.version       = DatasetExporter::VERSION
  spec.authors       = ["Kenneth Leung"]
  spec.email         = ["kenneth@leungs.us"]
  spec.summary       = %q{Save dataset to a file}
  spec.description   = %q{Save dataset to a file}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mhc_models"
  spec.add_development_dependency "os"
  spec.add_dependency "axlsx"
end
