class Blarg
  class Writer
    def self.dump(post)
      yaml_dump = YAML.safe_dump(post.front_matter)

      front_matter = yaml_dump
        .gsub(/title: '(.*)'/, 'title: \1')
        .gsub(/title: (.*)/, 'title: "\1"')

      data = [front_matter, post.content].join

      File.write(post.path, data)
    end
  end
end
