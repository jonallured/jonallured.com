class HeaderLine
  def self.create(width)
    Magick::Draw.new do |draw|
      draw.stroke = SocialImage::BLACK
      draw.stroke_width = width
    end
  end
end

class TitleText
  POINTSIZE = 60

  def self.generate
    Magick::Draw.new do |draw|
      draw.fill = SocialImage::BLACK
      draw.font = SocialImage::GEORGIA_PATH
      draw.gravity = Magick::CenterGravity
      draw.pointsize = POINTSIZE
    end
  end
end

class MetaText
  POINTSIZE = 40

  def self.generate
    Magick::Draw.new do |draw|
      draw.fill = SocialImage::BLACK
      draw.font = SocialImage::VERDANA_PATH
      draw.gravity = Magick::WestGravity
      draw.pointsize = POINTSIZE
    end
  end
end

class AuthorText
  POINTSIZE = 50

  def self.generate
    Magick::Draw.new do |draw|
      draw.fill = SocialImage::BLACK
      draw.font = SocialImage::GEORGIA_PATH
      draw.gravity = Magick::EastGravity
      draw.pointsize = POINTSIZE
    end
  end
end

class SocialImage
  WIDTH = 1024
  HEIGHT = 512

  WHITE = "#FFFFFF"
  BLACK = "#333333"

  GEORGIA_PATH = "/System/Library/Fonts/Supplemental/Georgia.ttf"
  VERDANA_PATH = "/System/Library/Fonts/Supplemental/Verdana.ttf"

  AVERAGE_WORDS_PER_MINUTE = 180

  def self.generate(post)
    new(post).generate
  end

  attr_reader :post, :social_image

  def initialize(post)
    @post = post
  end

  def generate
    create_image
    populate_image
    write_image
  end

  private

  def two_line_title?
    post.title_parts.size == 2
  end

  def create_image
    image_height = two_line_title? ? HEIGHT : HEIGHT - 80
    @social_image = Magick::Image.new(WIDTH, image_height) do |image|
      image.background_color = WHITE
      image.format = "png"
    end
  end

  def populate_image
    draw_top_line
    draw_title_lines
    draw_bottom_line
    draw_meta
    draw_headshot
    draw_author
  end

  def draw_top_line
    header_line = HeaderLine.create(3)
    header_line.line(50, 50, WIDTH - 50, 50)
    header_line.draw(social_image)
  end

  def draw_title_lines
    title_lines = post.title_parts
    pointsize = TitleText::POINTSIZE

    title_lines.each_with_index do |line, i|
      y_offset = (pointsize * i * 1.2) + 70
      TitleText.generate.annotate(social_image, WIDTH - 100, pointsize, 50, y_offset, line)
    end
  end

  def draw_bottom_line
    header_line = HeaderLine.create(6)
    y_offset = two_line_title? ? 220 : 150
    header_line.line(50, y_offset, WIDTH - 50, y_offset)
    header_line.draw(social_image)
  end

  def compute_meta
    word_count = post.content.split.size
    reading_time = (word_count / AVERAGE_WORDS_PER_MINUTE.to_f).ceil
    published_at = Date.parse(post.date)

    [
      "published #{published_at.strftime("%m/%d/%y")}",
      "#{word_count} words",
      "#{reading_time} minute read",
      "jon.zone/post-#{post.number}"
    ]
  end

  def draw_meta
    meta_lines = compute_meta
    pointsize = MetaText::POINTSIZE
    y_offset = two_line_title? ? 260 : 190

    meta_lines.each_with_index do |line, i|
      offset = (pointsize * i * 1.2) + y_offset
      MetaText.generate.annotate(social_image, WIDTH / 2, pointsize, 50, offset, line)
    end
  end

  def draw_headshot
    headshot_size = HEIGHT / 4
    append_image = Magick::Image.read("source/images/headshot.png").first.resize_to_fit(headshot_size)
    y_offset = two_line_title? ? 260 : 190
    social_image.composite!(append_image, WIDTH - headshot_size - 50, y_offset, Magick::OverCompositeOp)
  end

  def draw_author
    author = "Jon Allured".upcase
    y_offset = two_line_title? ? 400 : 330
    AuthorText.generate.annotate(social_image, WIDTH, AuthorText::POINTSIZE, 50, y_offset, author)
  end

  def write_image
    path = "source/images/post-#{post.number}/social-share.png"
    FileUtils.mkdir_p(File.dirname(path))
    social_image.write(path)
  end
end
