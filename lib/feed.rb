# frozen_string_literal: true

class Feed
  include Comparable

  attr_reader :name, :url

  def initialize(name, url)
    @name = name
    @url = url
  end

  def <=>(other)
    name.upcase <=> other.name.upcase
  end

  def to_hash
    {name: name, url: url}
  end
end
