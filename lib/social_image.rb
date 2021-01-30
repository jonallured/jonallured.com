# frozen_string_literal: true

require 'rmagick'

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

  WHITE = '#ffffff'
  BLACK = '#000000'

  GEORGIA_PATH = '/System/Library/Fonts/Supplemental/Georgia.ttf'
  VERDANA_PATH = '/System/Library/Fonts/Supplemental/Verdana.ttf'

  def self.generate(options)
    new(options).generate
  end

  attr_reader :options, :social_image

  def initialize(options)
    @options = options
  end

  def generate
    create_image
    populate_image
    write_image
  end

  private

  def create_image
    @social_image = Magick::Image.new(WIDTH, HEIGHT) do |image|
      image.background_color = WHITE
      image.format = 'png'
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
    title_lines = options[:title_parts]
    pointsize = TitleText::POINTSIZE

    title_lines.each_with_index do |line, i|
      y_offset = (pointsize * i * 1.2) + 70
      TitleText.generate.annotate(social_image, (WIDTH - 100), pointsize, 50, y_offset, line)
    end
  end

  def draw_bottom_line
    header_line = HeaderLine.create(6)
    header_line.line(50, 220, WIDTH - 50, 220)
    header_line.draw(social_image)
  end

  def compute_meta
    [
      "published #{options[:published_at].strftime('%m/%d/%y')}",
      "#{options[:word_count]} words",
      "#{options[:reading_time]} minute read",
      options[:shrt_url]
    ]
  end

  def draw_meta
    meta_lines = compute_meta
    pointsize = MetaText::POINTSIZE

    meta_lines.each_with_index do |line, i|
      offset = (pointsize * i * 1.2) + 260
      MetaText.generate.annotate(social_image, WIDTH / 2, pointsize, 50, offset, line)
    end
  end

  def draw_headshot
    headshot_size = HEIGHT / 4
    append_image = Magick::Image.read('source/images/headshot.png').first.resize_to_fit(headshot_size)
    y_offset = 260
    social_image.composite!(append_image, (WIDTH - headshot_size - 50), y_offset, Magick::OverCompositeOp)
  end

  def draw_author
    author = 'Jon Allured'.upcase
    AuthorText.generate.annotate(social_image, WIDTH, AuthorText::POINTSIZE, 50, 400, author)
  end

  def write_image
    path = options[:output_path]
    FileUtils.mkdir(File.dirname(path))
    social_image.write(path)
  end
end
