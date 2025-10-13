require "dotenv/tasks"
require "rspec/core/rake_task"

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

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec build]
