# frozen_string_literal: true

require_relative '../../lib/post_parser'

RSpec.describe PostParser do
  describe '.read' do
    it 'returns standard options' do
      options = PostParser.read(
        'source/posts/2020-12-23-dealing-with-rotten-links.html.md'
      )

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
