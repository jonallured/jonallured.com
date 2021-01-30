# frozen_string_literal: true

require_relative '../../lib/post_parser'

RSpec.describe PostParser do
  describe '.read' do
    it 'returns options' do
      path = 'source/posts/2016-09-16-adding-additional-virtual-hosts-to-a-digital-ocean-server.html.md'
      options = PostParser.read(path)

      expect(options).to eq(
        output_path: 'source/images/post-40/social-share.png',
        published_at: Date.parse('2016-09-16'),
        reading_time: 2,
        shrt_url: 'jon.zone/post-40',
        title_parts: ['Adding Additional Virtual Hosts to', 'a Digital Ocean Server'],
        word_count: 185
      )
    end

    it 'returns options' do
      path = 'source/posts/2020-12-23-dealing-with-rotten-links.html.md'
      options = PostParser.read(path)

      expect(options).to eq(
        output_path: 'source/images/post-41/social-share.png',
        published_at: Date.parse('2020-12-23'),
        reading_time: 3,
        shrt_url: 'jon.zone/post-41',
        title_parts: ['Dealing With Rotten Links'],
        word_count: 524
      )
    end
  end
end
