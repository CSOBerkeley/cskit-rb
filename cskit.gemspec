# encoding: UTF-8

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'cskit/version'

Gem::Specification.new do |s|
  s.name     = "cskit"
  s.version  = ::CSKit::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/CSOBerkeley/cskit-rb'

  s.description = s.summary = 'Christian Science citation library for Ruby.'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'json'

  s.require_path = 'lib'
  s.files = Dir['{lib,spec,resources}/**/*', 'Gemfile', 'History.txt', 'LICENSE', 'README.md', 'Rakefile', 'cskit.gemspec']
end
