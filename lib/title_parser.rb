# frozen_string_literal: true

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
