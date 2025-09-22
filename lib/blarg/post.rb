class Blarg
  class Post
    attr_reader :content, :date, :number, :path, :title_parts

    def initialize(attrs)
      @content = attrs[:content]
      @date = attrs[:date]
      @favorite = attrs[:favorite]
      @number = attrs[:number]
      @path = attrs[:path]
      @title = attrs[:title]
      @title_parts = attrs[:title_parts]
    end

    def front_matter
      {
        "date" => @date,
        "favorite" => @favorite,
        "number" => @number,
        "title" => @title
      }.compact
    end
  end
end
