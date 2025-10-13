require "active_support/core_ext/array/grouping"
require "nokogiri"
require "rmagick"
require "yaml"

require_relative "blarg/default_parser"
require_relative "blarg/draft_parser"
require_relative "blarg/feed"
require_relative "blarg/post"
require_relative "blarg/rotten_list"
require_relative "blarg/social_image"
require_relative "blarg/writer"

class Blarg
  def self.finalize_post(path)
    post = DefaultParser.post_for(path)
    Writer.dump(post)
    SocialImage.generate(post)
    post.number
  end

  def self.fix_rot(url)
    next_link = RottenList.fix(url)
    replace_command = "replace #{url} /rotten.html##{next_link.id} ./source/_posts/"
    puts replace_command
  end

  def self.setup_draft(path, type)
    post = DraftParser.post_for(path, type)
    Writer.dump(post)
    post.number
  end

  def self.update_feeds(feed_file, data_file)
    raise "can't find #{feed_file} file!" unless File.exist?(feed_file)

    data = File.read(feed_file)
    doc = Nokogiri::XML(data)
    nodes = doc.css("outline[type='rss']")

    feeds = nodes.map do |node|
      name = node.attributes["title"].value
      url = node.attributes["xmlUrl"].value

      Feed.new(name, url)
    end

    yaml = feeds.sort.map(&:to_hash).to_yaml
    File.write(data_file, yaml)
    FileUtils.rm(feed_file)
  end
end
