# frozen_string_literal: true

require 'yaml'
require 'date'
require 'active_support/all'

class TitleParser
  def self.parse(title)
    new(title).parse
  end

  attr_reader :title

  def initialize(title)
    @title = title
  end

  def parse
    if title.include?(';')
      parse_with_semi
    else
      simple_parse
    end
  end

  private

  def group_title_words
    words = title.split

    if words.length > 5 && words.length < 10
      words.in_groups(2, false)
    else
      words.in_groups_of(5, false)
    end
  end

  def clean_parts(grouped)
    if grouped.count > 2
      first, last = grouped.take(2)
      cutoff = last.length + 2
      [first, maybe_snip_part(last, cutoff, force: true)]
    else
      cutoff = 35

      grouped.map do |part|
        maybe_snip_part(part, cutoff)
      end
    end
  end

  def simple_parse
    word_groups = group_title_words
    grouped = word_groups.map { |group| group.join(' ') }
    clean_parts(grouped)
  end

  def parse_with_semi
    first, last = title.split('; ').take(2)
    first << ';'
    parts = [first, last]
    cutoff = 31

    parts.map do |part|
      maybe_snip_part(part, cutoff)
    end
  end

  def maybe_snip_part(part, cutoff, force: false)
    return part unless part.length > cutoff || force

    punctuation_list = [',', ';', '.']
    offset = punctuation_list.include?(part.last) ? 4 : 3
    end_index = cutoff - offset
    suffix = part.last == ';' ? ';' : ''

    "#{part[0..end_index].strip}...#{suffix}"
  end
end

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
    front_matter['id']
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
    TitleParser.parse(front_matter['title'])
  end

  def word_count
    body.split.size
  end
end

class PostParser
  def self.read(path)
    data = File.read(path)
    _, yaml, body = data.split('---')
    front_matter = YAML.safe_load(yaml)

    PostOptions.as_hash(path, front_matter, body)
  end
end
