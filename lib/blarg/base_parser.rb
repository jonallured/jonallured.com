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
    end

    def to_hash
      {
        content: @content,
        date: @loaded_front_matter["date"],
        favorite: @loaded_front_matter["favorite"],
        number: @loaded_front_matter["number"],
        path: @path,
        title: @loaded_front_matter["title"]
      }
    end
  end
end
