# frozen_string_literal: true

require_relative '../post_parser'
require_relative '../social_image'

desc 'Generate social image'
task :social_image, [:path] do |_task, args|
  path = args[:path]
  options = PostParser.read(path)
  SocialImage.generate(options)
end

desc 'Generate all social images'
task :all_social_images do
  paths = Dir.glob('source/posts/*.md')
  paths.each do |path|
    options = PostParser.read(path)
    SocialImage.generate(options)
  end
end
