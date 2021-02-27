# frozen_string_literal: true

class RottenList
  attr_reader :links

  def initialize(raw_data)
    @links = raw_data.map { |data| Link.new(data) }
  end

  def next_link(url)
    data = {
      'id' => next_id,
      'url' => url
    }
    link = Link.new(data)
    links << link
    link
  end

  private

  def next_id
    links.map(&:id).max + 1
  end

  class Link
    include Comparable

    attr_reader :id, :url

    def initialize(data)
      @id = data['id']
      @url = data['url']
    end

    def <=>(other)
      id <=> other.id
    end

    def to_hash
      { 'id' => id, 'url' => url }
    end
  end
end
