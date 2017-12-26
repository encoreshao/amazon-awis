# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awis/version'

Gem::Specification.new do |spec|
  spec.name          = "awis-sdk-ruby"
  spec.version       = Awis::VERSION
  spec.authors       = ["Encore Shao"]
  spec.email         = ["encore.shao@gmail.com"]

  spec.summary       = %q{Ruby - Amazon Alexa Web Information Service Library (AWIS)}
  spec.description   = %q{Ruby - Amazon Alexa Web Information Service Library (AWIS)}
  spec.homepage      = "https://github.com/encoreshao/amazon-awis"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "multi_xml", ">= 0.5.0"
  spec.add_dependency "nokogiri", '~> 1.6.8'

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
end
