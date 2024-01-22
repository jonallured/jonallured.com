desc "Generate next article id"
task :next_article_id do
  most_recent_post_path = Dir.glob("source/posts/*.md").max
  data = File.read(most_recent_post_path)
  yaml = YAML.safe_load(data)
  id = yaml["id"]
  puts id + 1
end
