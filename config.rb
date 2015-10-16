page '*', layout: :default
page '/posts/*', layout: :post
page 'atom.xml', layout: false
page '/jack/*', layout: false

activate :blog do |blog|
  blog.sources = 'posts/{year}-{month}-{day}-{title}.html'
  blog.default_extension = '.md'
end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

set :markdown_engine, :redcarpet

configure :development do
  activate :google_analytics do |ga|
    ga.tracking_id = false
  end
end

configure :build do
  activate :google_analytics do |ga|
    ga.tracking_id = 'UA-3137727-1'
  end
end
