class Blarg
  class Post
    attr_reader :content, :date, :number, :path, :title_parts

    def initialize(attrs)
      @content = attrs[:content]
      @date = attrs[:date]
      @number = attrs[:number]
      @path = attrs[:path]
      @tags = attrs[:tags]
      @title = attrs[:title]
      @title_parts = attrs[:title_parts]
    end

    def front_matter
      {
        "date" => @date,
        "number" => @number,
        "tags" => @tags,
        "title" => @title
      }.compact
    end
  end
end
