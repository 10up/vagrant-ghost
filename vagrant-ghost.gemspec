# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-ghost/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-ghost"
  spec.version       = VagrantPlugins::Ghost::VERSION
  spec.authors       = ["John P Bloch", "Eric Mann"]
  spec.email         = ["john.bloch@10up.com","eric.mann@10up.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = "Update Hosts"
  spec.description   = "Update hosts"
  spec.homepage      = "https://github.com/10up/vagrant-ghost"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
