# frozen_string_literal: true

require 'date'
require 'active_support'
require 'nokogiri'
require 'yaml'
require 'dotenv'
require 'rubocop/rake_task'
require 'html-proofer'

Rake.add_rakelib 'lib/tasks'
Dotenv.load

desc 'Build Middleman site'
task :build do
  exit 1 unless system 'bundle exec middleman build'
end

desc 'Check generated HTML'
task :check_html do
  options = { assume_extension: true, disable_external: true }
  HTMLProofer.check_directory('build', options).run
end

desc 'Check external links'
task :check_links do
  options = { assume_extension: true, checks_to_ignore: %w[ImageCheck ScriptCheck], external_only: true }
  HTMLProofer.check_directory('build', options).run
end

desc 'Deploy site'
task :deploy do
  system 'middleman build --clean'
  system "rsync -av -e ssh --delete build/ #{ENV['DEPLOY_TARGET']}"
end

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop)

task default: %i[rubocop build check_html]
