# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gakky_bot/version'

Gem::Specification.new do |spec|
  spec.name          = "gakky_bot"
  spec.version       = GakkyBot::VERSION
  spec.authors       = ["Michael"]
  spec.email         = ["kobelu1990@gmail.com"]

  spec.summary       = %q{gakky bot.}
  spec.description   = %q{Update posts automatically}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

end