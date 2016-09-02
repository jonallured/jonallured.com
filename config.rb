page '*', layout: :default
page '/posts/*', layout: :post
page 'atom.xml', layout: false
page '/jack/*', layout: false

activate :blog do |blog|
  blog.sources = '{year}-{month}-{day}-{title}'
  blog.prefix = 'posts'
  blog.default_extension = '.md'
end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

set :markdown_engine, :redcarpet

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-3137727-1'
  ga.development = false
end
