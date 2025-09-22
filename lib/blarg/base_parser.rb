require "active_support/core_ext/array/grouping"

class Blarg
  class BaseParser
    def self.post_for(path)
      parser = new(path)
      parser.run
      attrs = parser.to_hash
      Post.new(attrs)
    end

    def initialize(path)
      @path = path
    end

    def run
      data = File.read(@path)
      _empty, yaml, *rest = data.split("---")
      @loaded_front_matter = YAML.safe_load(yaml)
      @content = "---\n" + rest.join("---")
      @title = @loaded_front_matter["title"]
      @title_parts = grab_title_parts
    end

    def to_hash
      {
        content: @content,
        date: @loaded_front_matter["date"],
        favorite: @loaded_front_matter["favorite"],
        number: @loaded_front_matter["number"],
        path: @path,
        title: @title,
        title_parts: @title_parts
      }
    end

    private

    def grab_title_parts
      if @title.include?(";")
        parse_with_semi
      else
        simple_parse
      end
    end

    def group_title_words
      words = @title.split

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
      grouped = word_groups.map { |group| group.join(" ") }
      clean_parts(grouped)
    end

    def parse_with_semi
      first, last = @title.split("; ").take(2)
      first << ";"
      parts = [first, last]
      cutoff = 31

      parts.map do |part|
        maybe_snip_part(part, cutoff)
      end
    end

    def maybe_snip_part(part, cutoff, force: false)
      return part unless part.length > cutoff || force

      punctuation_list = [",", ";", "."]
      offset = punctuation_list.include?(part.last) ? 4 : 3
      end_index = cutoff - offset
      suffix = (part.last == ";") ? ";" : ""

      "#{part[0..end_index].strip}...#{suffix}"
    end
  end
end
