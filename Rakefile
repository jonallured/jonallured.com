require 'date'
require 'active_support'
require 'nokogiri'
require 'yaml'
require 'dotenv'

require './lib/feed'

Dotenv.load

desc 'Build Middleman site'
task :build do
  exit 1 unless system 'bundle exec middleman build'
end

desc 'Verify generated HTML'
task :verify_html do
  exit 2 unless system 'bundle exec htmlproofer ./build'
end

desc 'Deploy site'
task :deploy do
  system 'middleman build --clean'
  system "rsync -av -e ssh --delete build/ #{ENV['DEPLOY_TARGET']}"
end

desc 'Parse Feedbin Subscription File'
task :parse_subs do
  unless File.exists? './subscriptions.xml'
    puts "can't find subscriptions.xml file!"
    exit 1
  end

  doc = File.open('subscriptions.xml') { |file| Nokogiri::XML file }

  feeds = doc.css('outline').map do |node|
    name = node.attributes['title'].value
    url = node.attributes['xmlUrl'].value

    Feed.new name, url
  end

  yaml = feeds.sort.map(&:to_hash).to_yaml
  File.write 'data/feeds.yml', yaml
end

task default: [:build, :verify_html]
