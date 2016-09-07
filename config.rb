set :layout, :default

page '/posts/*', layout: :post
page 'atom.xml', layout: false
page '/jack/*', layout: false

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

set :markdown_engine, :redcarpet

activate :blog do |blog|
  blog.prefix = 'posts'
end

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-3137727-1'
  ga.development = false
end
