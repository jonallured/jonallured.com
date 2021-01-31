# frozen_string_literal: true

require 'yaml'
require './lib/post_options'

class PostParser
  def self.read(path)
    data = File.read(path)
    _, yaml, body = data.split('---')
    front_matter = YAML.safe_load(yaml)

    PostOptions.as_hash(path, front_matter, body)
  end
end
