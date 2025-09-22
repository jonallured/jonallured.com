require "active_support/core_ext/array/grouping"
require "rmagick"
require "yaml"

require_relative "blarg/default_parser"
require_relative "blarg/draft_parser"
require_relative "blarg/social_image"
require_relative "blarg/post"
require_relative "blarg/writer"

class Blarg
  def self.setup_draft(path, type)
    post = DraftParser.post_for(path, type)
    Writer.dump(post)
    post.number
  end

  def self.finalize_post(path)
    post = DefaultParser.post_for(path)
    Writer.dump(post)
    SocialImage.generate(post)
    post.number
  end
end
