# encoding: UTF-8

# Copyright 2012 Twitter, Inc
# http://www.apache.org/licenses/LICENSE-2.0

require 'rubygems' unless ENV['NO_RUBYGEMS']

require 'bundler'
require 'digest'

require 'rspec/core/rake_task'
require 'rubygems/package_task'

require './lib/cskit'

Bundler::GemHelper.install_tasks

task :default => :spec

desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
  t.pattern = './spec/**/*_spec.rb'
end

if RUBY_VERSION < '1.9.0'
  desc 'Run specs with RCov'
  RSpec::Core::RakeTask.new('spec:cov') do |t|
    t.rcov       = true
    t.pattern    = './spec/**/*_spec.rb'
    t.rcov_opts  = '-T --sort coverage --exclude gems/,spec/'
  end

  desc 'Run full specs suit with RCov'
  task 'spec:cov:full' => %w[spec:full_spec_env spec:cov]
else
  namespace :spec do
    desc 'Run specs with SimpleCov'
    task :cov => ['spec:simplecov_env', :spec] do
      require 'launchy'
      Launchy.open 'coverage/index.html'
    end

    desc 'Run full specs suit with SimpleCov'
    task 'cov:full' => %w[spec:full_spec_env spec:cov]

    task :simplecov_env do
      puts 'Cleaning up coverage reports'
      rm_rf 'coverage'

      ENV['SCOV'] = 'true'
    end
  end
end