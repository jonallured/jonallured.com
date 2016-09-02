require 'date'
require 'active_support'
require 'dotenv'
Dotenv.load

desc 'Build Middleman site'
task :build do
  exit 1 unless system 'bundle exec middleman build'
end

desc 'Verify generated HTML'
task :verify_html do
  exit 2 unless system 'bundle exec htmlproofer ./build'
end

desc 'Deploy site'
task :deploy do
  system 'middleman build --clean'
  system "rsync -av -e ssh --delete build/ #{ENV['DEPLOY_TARGET']}"
end

task default: [:build, :verify_html]
