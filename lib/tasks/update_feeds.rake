# frozen_string_literal: true

require "./lib/feed"

desc "Update list of feeds"
task :update_feeds do
  unless File.exist? "./subscriptions.xml"
    puts "can't find subscriptions.xml file!"
    exit 1
  end

  doc = File.open("subscriptions.xml") { |file| Nokogiri::XML file }

  feeds = doc.css("outline").map do |node|
    name = node.attributes["title"].value
    url = node.attributes["xmlUrl"].value

    Feed.new name, url
  end

  yaml = feeds.sort.map(&:to_hash).to_yaml
  File.write "data/feeds.yml", yaml
end

desc "Update list of podcasts"
task :update_podcasts do
  unless File.exist? "./overcast.opml"
    puts "can't find overcast.opml file!"
    exit 1
  end

  doc = File.open("overcast.opml") { |file| Nokogiri::XML file }

  podcasts = doc.css("outline[type='rss']").map do |node|
    name = node.attributes["title"].value
    url = node.attributes["xmlUrl"].value

    Feed.new name, url
  end

  yaml = podcasts.sort.map(&:to_hash).to_yaml
  File.write "data/podcasts.yml", yaml
end
