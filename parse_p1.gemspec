# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "parse_p1/version"

Gem::Specification.new do |s|
  s.name        = "parse_p1"
  s.version     = ParseP1::VERSION
  s.authors     = ["Frank Oxener"]
  s.email       = ["frank.oxener@gmail.com"]
  s.homepage    = %q{http://github.com/dovadi/parse_p1}
  s.summary     = %q{Parsing P1 Companion Standard used by Dutch Smart Meters}
  s.description = %q{Parsing P1 Companion Standard used by Dutch Smart Meters. Used in combination with a Nanode posting the P1 data to emonWeb.org}
  s.licenses    = ['MIT']
  s.rubyforge_project = "parse_p1"

  s.extra_rdoc_files = [
     'CHANGELOG',
     'LICENSE.txt',
     'README.md'
   ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-test'

end
