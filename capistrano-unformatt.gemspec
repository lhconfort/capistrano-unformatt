# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "capistrano-unformatt"
  spec.version       = '1.14.1'
  spec.authors       = ["unformatt"]
  spec.email         = ["unformatt@gmail.com"]
  spec.description   = "Custom recipes for Unformatt projects"
  spec.summary       = "Custom recipes for Unformatt projects"
  spec.homepage      = "https://github.com/unformattmh/capistrano-unformatt"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency "capistrano", ">= 3.0"
  spec.add_dependency "capistrano-template", ">= 0.0.7"
end
