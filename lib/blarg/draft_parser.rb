class Blarg
  class DraftParser < BaseParser
    TYPE_TO_TEMPLATE_MAP = {
      default: "post_templates/default.md",
      wir: "post_templates/wir.md"
    }

    def self.post_for(path, type)
      parser = new(path)
      parser.type = type
      parser.run
      attrs = parser.to_hash
      Post.new(attrs)
    end

    attr_accessor :type

    def run
      super

      template_path = TYPE_TO_TEMPLATE_MAP[@type.to_sym]
      data = File.read(template_path)
      @content = "---\n\n" + data
    end

    def to_hash
      super.merge({
        date: nil,
        favorite: false,
        number: next_post_number
      })
    end

    private

    def next_post_number
      Dir.glob("source/_posts/*.md").count + 1
    end
  end
end
