# encoding: UTF-8

# Copyright 2012 Twitter, Inc
# http://www.apache.org/licenses/LICENSE-2.0

require 'rubygems' unless ENV['NO_RUBYGEMS']

require 'bundler'
require 'digest'

require 'rubygems/package_task'

Bundler::GemHelper.install_tasks

namespace :parsers do
  task :compile do
    base_path = File.dirname(__FILE__)
    parser_paths = [
      "lib/cskit/parsers/bible/bible.treetop",
      "lib/cskit/parsers/science_health/science_health.treetop"
    ]

    parser_paths.each do |parser_path|
      full_path = File.join(base_path, parser_path)
      puts "Compiling #{full_path}"
      `bundle exec tt #{full_path}`
    end
  end
end