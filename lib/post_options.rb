# frozen_string_literal: true

require "date"
require "./lib/title_parser"

class PostOptions
  AVERAGE_WORDS_PER_MINUTE = 180

  attr_reader :path, :front_matter, :body

  def self.as_hash(path, front_matter, body)
    new(path, front_matter, body).as_hash
  end

  def initialize(path, front_matter, body)
    @path = path
    @front_matter = front_matter
    @body = body
  end

  def as_hash
    {
      output_path: output_path,
      published_at: published_at,
      reading_time: reading_time,
      shrt_url: shrt_url,
      title_parts: title_parts,
      word_count: word_count
    }
  end

  private

  def id
    front_matter["id"]
  end

  def output_path
    "source/images/post-#{id}/social-share.png"
  end

  def published_at
    Date.parse(path[13, 10])
  end

  def reading_time
    (word_count / AVERAGE_WORDS_PER_MINUTE.to_f).ceil
  end

  def shrt_url
    "jon.zone/post-#{id}"
  end

  def title_parts
    TitleParser.parse(front_matter["title"])
  end

  def word_count
    body.split.size
  end
end
