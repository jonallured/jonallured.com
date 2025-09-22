require_relative "../blarg"

desc "Fix rotten link at URL"
task :fix_rot, [:url] do |_task, args|
  url = args[:url]

  unless url
    puts "Run like this: 'rake fix_rot[http://www.example.com/path/to/page.html]'"
    exit 1
  end

  Blarg.fix_rot(url)
end
