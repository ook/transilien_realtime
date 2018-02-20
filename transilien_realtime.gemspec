# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transilien_realtime/version'

Gem::Specification.new do |spec|
  spec.name          = "transilien_realtime"
  spec.version       = TransilienRealtime::VERSION
  spec.authors       = ["Thomas Lecavelier"]
  spec.email         = ["thomas@lecavelier.name"]

  spec.summary       = %q{Implementation of SNCF Transilien API Temps Réel}
  spec.description   = %q{Let you query the next trains on given stations, eventually toward a given station}
  spec.homepage      = "https://github.com/ook/transilien_realtime"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'http', '~> 3.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.8.2'
  spec.add_runtime_dependency 'oj', '~> 3.4'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry", "~> 0.11.3"
end
