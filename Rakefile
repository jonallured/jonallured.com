require "dotenv/tasks"

Rake.add_rakelib "lib/tasks"

desc "Deploy site"
task deploy: :dotenv do
  system "jekyll build"
  system "rsync -av -e ssh --delete build/ #{ENV["DEPLOY_TARGET"]}"
end
