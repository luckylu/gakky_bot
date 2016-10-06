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
  spec.add_dependency "httparty",  "~> 0.14.0"
  spec.add_dependency 'activerecord', '~> 5.0', '>= 5.0.0.1'
  spec.add_dependency 'mysql2', '~> 0.4.4'
  spec.add_dependency 'nokogiri', '~> 1.6', '>= 1.6.8'
  spec.add_dependency 'activesupport', '~> 5.0', '>= 5.0.0.1'
  spec.add_dependency "rest-client"
  spec.add_dependency 'whenever', '~> 0.9.7'
  spec.add_dependency 'thor', '~> 0.19.1'
end
