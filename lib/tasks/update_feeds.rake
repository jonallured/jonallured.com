require_relative "../blarg"

desc "Update list of feeds"
task :update_feeds do
  feed_file = "subscriptions.xml"
  data_file = "source/_data/feeds.yml"

  Blarg.update_feeds(feed_file, data_file)
end
