# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "ruby_danfe/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_danfe"
  spec.version       = RubyDanfe::VERSION
  spec.summary       = "DANFE and DACTE pdf generator for Brazilian invoices and transportation docs."
  spec.author        = "Eduardo Reboucas"
  spec.email         = "eduardo.reboucas@gmail.com"
  spec.homepage      = "http://github.com/taxweb/ruby_danfe"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "nokogiri", "~> 1.8"
  spec.add_dependency "prawn", "~> 1.2"
  spec.add_dependency "prawn-table", "~> 0.2"
  spec.add_dependency "barby", "~> 0.5"
  spec.add_dependency "rqrcode", "~> 0.10"
  spec.add_dependency "rake"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
end
