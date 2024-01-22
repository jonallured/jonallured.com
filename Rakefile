# frozen_string_literal: true

require "active_support"
require "date"
require "dotenv"
require "html-proofer"
require "nokogiri"
require "rspec/core/rake_task"
require "standard/rake"
require "yaml"

Rake.add_rakelib "lib/tasks"
Dotenv.load

desc "Build Middleman site"
task :build do
  exit 1 unless system "bundle exec middleman build"
end

desc "Check generated HTML"
task :check_html do
  options = {assume_extension: true, disable_external: true}
  HTMLProofer.check_directory("build", options).run
end

desc "Check external links"
task :check_links do
  options = {assume_extension: true, checks_to_ignore: %w[ImageCheck ScriptCheck], external_only: true}
  HTMLProofer.check_directory("build", options).run
end

desc "Deploy site"
task :deploy do
  system "middleman build --clean"
  system "rsync -av -e ssh --delete build/ #{ENV["DEPLOY_TARGET"]}"
end

RSpec::Core::RakeTask.new(:spec)

task default: %i[standard spec build]
