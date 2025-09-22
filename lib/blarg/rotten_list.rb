class RottenList
  attr_reader :links

  def self.fix(url)
    path = "source/_data/rotten_links.yml"
    raw_data = YAML.safe_load_file(path)
    rotten_list = new(raw_data)
    next_link = rotten_list.next_link(url)
    data = rotten_list.to_yaml
    File.write(path, data)
    next_link
  end

  def initialize(raw_data)
    @links = raw_data.map { |data| Link.new(data) }
  end

  def next_link(url)
    data = {
      "id" => next_id,
      "url" => url
    }
    link = Link.new(data)
    links << link
    link
  end

  def to_yaml
    links.sort.map(&:to_hash).to_yaml
  end

  private

  def next_id
    links.map(&:id).max + 1
  end

  class Link
    include Comparable

    attr_reader :id, :url

    def initialize(data)
      @id = data["id"]
      @url = data["url"]
    end

    def <=>(other)
      id <=> other.id
    end

    def to_hash
      {"id" => id, "url" => url}
    end
  end
end
