require_relative "../blarg"

desc "Update list of podcasts"
task :update_podcasts do
  feed_file = "overcast.opml"
  data_file = "source/_data/podcasts.yml"

  raise "can't find #{feed_file} file!" unless File.exist?(feed_file)

  Blarg.update_feeds(feed_file, data_file)
  FileUtils.rm(feed_file)
end
