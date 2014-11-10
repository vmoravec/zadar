# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zadar/version'

Gem::Specification.new do |spec|
  spec.name          = "zadar"
  spec.version       = Zadar::VERSION
  spec.authors       = ["Vladimir Moravec"]
  spec.email         = ["vmoravec@suse.com"]
  spec.summary       = %q{Zadar - Virtual Machine Management}
  spec.description   = %q{Get image. Install machine. Make snapshots. Use them}
  spec.homepage      = "https://github.com/vmoravec/zadar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", "~> 4.1"
  spec.add_runtime_dependency "ruby-libvirt", "~> 0.5"
  spec.add_runtime_dependency "gli", "~> 2.1"
  spec.add_runtime_dependency "nokogiri"

  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
