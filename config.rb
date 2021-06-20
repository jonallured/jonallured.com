# frozen_string_literal: true

Haml::TempleEngine.disable_option_validator!

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
  blog.new_article_template = File.expand_path('article_templates/default.erb', File.dirname(__FILE__))
end

activate :livereload
