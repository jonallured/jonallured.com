require "yaml"
require_relative "blarg/base_parser"
require_relative "blarg/draft_parser"
require_relative "blarg/post"
require_relative "blarg/writer"

class Blarg
  def self.setup_draft(path, type)
    post = DraftParser.post_for(path, type)
    Writer.dump(post)
    post.number
  end

  def self.finalize_post(path)
    post = BaseParser.post_for(path)
    Writer.dump(post)
    post.number
  end
end
