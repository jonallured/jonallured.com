# frozen_string_literal: true

require 'yaml'
require 'date'
require 'active_support/all'

class PostParser
  AVERAGE_WORDS_PER_MINUTE = 180

  def self.read(path)
    data = File.read(path)
    _, yaml, body = data.split('---')
    front_matter = YAML.safe_load(yaml)
    word_count = body.split.size

    compute_options(path, word_count, front_matter)
  end

  def self.compute_options(path, word_count, front_matter)
    id = front_matter['id']
    reading_time = (word_count / AVERAGE_WORDS_PER_MINUTE.to_f).ceil

    {
      output_path: "source/images/post-#{id}/social-share.png",
      published_at: Date.parse(path[13, 10]),
      reading_time: reading_time,
      shrt_url: "jon.zone/post-#{id}",
      title_parts: compute_title_parts(front_matter['title']),
      word_count: word_count
    }
  end

  def self.compute_title_parts(title)
    split_up = title.split
    grouped = split_up.in_groups_of(5, false)
    grouped.map { |group| group.join(' ') }
  end
end
