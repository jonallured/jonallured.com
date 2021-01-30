# frozen_string_literal: true

paths = Dir.glob('source/posts/*.md')

paths.each do |path|
  data = File.read(path)
  title_line = data.lines.find { |line| line.match(/title: .*/) }
  target = title_line.split(': ').last.chomp

  replace_command = "echo #{target} | titlecase"
  replacement = `#{replace_command}`.chomp

  sed_command = "sed -i '' \"s/title: #{target}/title: #{replacement}/g\" #{path}"
  puts sed_command
  system(sed_command)

  subhead_lines = data.lines.select { |line| line.match(/##.*/) }
  subhead_lines.each do |subhead_line|
    target = subhead_line[3..].chomp

    replace_command = "echo #{target} | titlecase"
    replacement = `#{replace_command}`.chomp

    sed_command = "sed -i '' \"s/## #{target}/## #{replacement}/g\" #{path}"
    puts sed_command
    system(sed_command)
  end
end
