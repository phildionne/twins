# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'twins/version'

Gem::Specification.new do |s|
  s.name          = "twins"
  s.version       = Twins::VERSION
  s.authors       = ["Philippe Dionne"]
  s.email         = ["dionne.phil@gmail.com"]
  s.homepage      = "https://github.com/phildionne/twins"
  s.licenses      = ['MIT']
  s.summary       = "Smartly merge multiple objects together."
  s.description   = "Twin sorts through the small differences between multiple objects and smartly consolidate all of them together."

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
  s.test_files    = s.files.grep(%r{^(spec)/})

  s.add_dependency 'activesupport'
  s.add_dependency 'amatch', '~> 0.3'
end
