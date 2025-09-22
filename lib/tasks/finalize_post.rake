require_relative "../blarg"

desc "Finalize post at PATH"
task :finalize_post, [:path] do |_task, args|
  path = args[:path]
  number = Blarg.finalize_post(path)
  puts number
end
