# frozen_string_literal: true

require './lib/rotten_list'

desc 'Fix rotten link'
task :fix_rot, [:url] do |_t, args|
  url = args[:url]
  error_message = "Run like this: 'rake fix_rot[http://www.example.com/path/to/file.html]'"

  unless url
    puts error_message
    exit 1
  end

  path = 'data/rotten_links.yml'
  raw_data = YAML.safe_load(File.read(path))
  rotten_list = RottenList.new(raw_data)

  next_link = rotten_list.next_link(url)

  yaml = rotten_list.links.sort.map(&:to_hash).to_yaml
  File.write(path, yaml)

  replace_command = "replace #{url} rotten.html##{next_link.name} ./source/posts/"
  system replace_command
end
