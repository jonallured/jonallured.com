# frozen_string_literal: true

require_relative '../../lib/post_parser'

RSpec.describe PostParser do
  describe '.read' do
    context 'with a single line title' do
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

    context 'with a double line title' do
      it 'returns options with two title parts' do
        options = PostParser.read(
          'source/posts/2016-09-16-adding-additional-virtual-hosts-to-a-digital-ocean-server.html.md'
        )

        expect(options[:title_parts]).to eq(
          [
            'Adding Additional Virtual Hosts to',
            'a Digital Ocean Server'
          ]
        )
      end
    end

    context 'with a title that has a semi colon' do
      it 'returns options with the title parts split on that semi colon' do
        options = PostParser.read(
          'source/posts/2012-01-31-the-simpleton-pattern-when-to-include-when-to-extend.html.md'
        )

        expect(options[:title_parts]).to eq(
          [
            'The Simpleton Pattern;',
            'When to Include, When to Extend'
          ]
        )
      end
    end

    context 'with a title that has a semi and is too long' do
      it 'returns options with a last title part thats been snipped' do
        options = PostParser.read(
          'source/posts/2012-01-12-delayed-job-hits-3-marston-on-deprecating-legacy-code.html.md'
        )

        expect(options[:title_parts]).to eq(
          [
            'Delayed Job Hits 3.0;',
            'Marston on Deprecating Legacy...'
          ]
        )
      end
    end

    context 'with a title that has a semi colon and the first part is too long' do
      it 'returns options with title parts that include a first part that has been snipped' do
        options = PostParser.read(
          'source/posts/2011-12-19-multiple-carets-in-textmate-2-default-scope.html.md'
        )

        expect(options[:title_parts]).to eq(
          [
            'Multiple Carets in TextMate...;',
            'Default Scope'
          ]
        )
      end
    end

    context 'with a really long title' do
      it 'returns options with a final title part that has been snipped' do
        options = PostParser.read(
          'source/posts/2011-08-08-keeping-a-live-website-in-sync-with-a-local-version-part-one.html.md'
        )

        expect(options[:title_parts]).to eq(
          [
            'Keeping a Live Website in',
            'Sync With a Local Version...'
          ]
        )
      end
    end

    context 'with a medium title' do
      it 'returns options with two title parts' do
        options = PostParser.read(
          'source/posts/2011-11-28-playing-around-with-content-editable-in-rails.html.md'
        )

        expect(options[:title_parts]).to eq(
          [
            'Playing Around With Content',
            'Editable in Rails'
          ]
        )
      end
    end

    context 'with a long title ending in a period' do
      it 'returns options that have a final title part with that trailing period removed' do
        options = PostParser.read(
          'source/posts/2012-02-06-klabnik-on-moving-from-sinatra-to-rails-and-acceptance-vs-integration-tests.html.md'
        )

        expect(options[:title_parts]).to eq(
          [
            'Klabnik on Moving From Sinatra',
            'to Rails and Acceptance vs...'
          ]
        )
      end
    end
  end
end
