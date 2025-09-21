require_relative "../blarg"

desc "Setup draft at PATH with TYPE"
task :setup_draft, [:path, :type] do |_task, args|
  path = args[:path].gsub(/\e\[[\d;]+m/, "")
  type = args[:type]
  number = Blarg.setup_draft(path, type)
  puts number
end
