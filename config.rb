# frozen_string_literal: true

set :layout, :default

page 'atom.xml', layout: false
page '/jack/*', layout: false

set :css_dir, 'css'
set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true

activate :blog do |blog|
  blog.prefix = 'posts'
  blog.layout = 'post'
  blog.default_extension = '.md'
end

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-3137727-1'
end
