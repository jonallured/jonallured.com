# frozen_string_literal: true

require_relative '../../lib/title_parser'

RSpec.describe TitleParser do
  describe 'with a short title' do
    it 'returns one title part' do
      title = 'Dealing With Rotten Links'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'Dealing With Rotten Links'
        ]
      )
    end
  end

  describe 'with a medium title' do
    it 'returns two balanced title parts' do
      title = 'Playing Around With Content Editable in Rails'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'Playing Around With Content',
          'Editable in Rails'
        ]
      )
    end
  end

  describe 'with a long title' do
    it 'returns two balanced title parts' do
      title = 'Adding Additional Virtual Hosts to a Digital Ocean Server'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'Adding Additional Virtual Hosts to',
          'a Digital Ocean Server'
        ]
      )
    end
  end

  describe 'with a really long title' do
    it 'returns two title parts and the last one has been snipped' do
      title = 'Keeping a Live Website in Sync With a Local Version, Part One'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'Keeping a Live Website in',
          'Sync With a Local Version...'
        ]
      )
    end
  end

  describe 'with a title that has a semi colon' do
    it 'returns two title parts split by semi' do
      title = 'The Simpleton Pattern; When to Include, When to Extend'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'The Simpleton Pattern;',
          'When to Include, When to Extend'
        ]
      )
    end
  end

  describe 'with a title that has a semi and the second part is too long' do
    it 'returns two title parts split by semi and snips last one' do
      title = 'Delayed Job Hits 3.0; Marston on Deprecating Legacy Code'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'Delayed Job Hits 3.0;',
          'Marston on Deprecating Legacy...'
        ]
      )
    end
  end

  describe 'with a title that has a semi and the first part is too long' do
    it 'returns two parts split by semi and snips the first one' do
      title = 'Multiple Carets in TextMate 2.0; Default Scope'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'Multiple Carets in TextMate...;',
          'Default Scope'
        ]
      )
    end
  end

  describe 'with a long title ending in a period' do
    it 'returns two parts and the second one is snipped without period' do
      title = 'Klabnik on Moving From Sinatra to Rails and Acceptance vs. Integration Tests'
      parts = TitleParser.parse(title)
      expect(parts).to eq(
        [
          'Klabnik on Moving From Sinatra',
          'to Rails and Acceptance vs...'
        ]
      )
    end
  end
end
