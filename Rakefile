require "dotenv/tasks"
require "rspec/core/rake_task"
require "standard/rake"

Rake.add_rakelib "lib/tasks"

desc "Build Middleman site"
task :build do
  exit 1 unless system "bundle exec jekyll build --quiet"
end

desc "Deploy site"
task deploy: :dotenv do
  system "jekyll build"
  system "rsync -av -e ssh --delete build/ #{ENV["DEPLOY_TARGET"]}"
end

RSpec::Core::RakeTask.new(:spec) { |t| t.verbose = false }

task default: %i[standard spec build]
