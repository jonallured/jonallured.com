require "dotenv/tasks"
require "html-proofer"
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

desc "Run HTMLProofer again build folder"
task :proof_html do
  # options = {assume_extension: true, disable_external: true}
  # options = {}
  options = {
    ignore_urls: [/2RadDads/]
  }
  # HTMLProofer.check_file("build/index.html", options).run
  HTMLProofer.check_directory("build", options).run
end

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec build]
