# encoding: UTF-8

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'cskit/version'

Gem::Specification.new do |s|
  s.name     = "cskit"
  s.version  = ::CSKit::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/camertron"

  s.description = s.summary = "Christian Science citation library for Ruby."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'json'
  s.add_dependency 'treetop'

  s.add_development_dependency 'rake'

  s.require_path = 'lib'

  gem_files       = Dir["{lib,spec,resources}/**/*", "Gemfile", "History.txt", "LICENSE", "README.md", "Rakefile", "cskit.gemspec"]
  versioned_files = `git ls-files`.split("\n")

  s.files = gem_files & versioned_files
end
