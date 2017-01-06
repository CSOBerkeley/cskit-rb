# encoding: UTF-8

require 'spec_helper'

include CSKit::Parsers::Bible

describe BibleParser do
  let(:parser) { described_class.new(citation_text) }

  context 'single chapter, single verse' do
    let(:citation_text) { 'Genesis 1:1' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, starter: nil, terminator: nil
          }]
        }]
      })
    end
  end

  context 'single chapter, single verse, numbered book name' do
    let(:citation_text) { 'II Chronicles 1:1' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'II Chronicles', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, starter: nil, terminator: nil
          }]
        }]
      })
    end
  end

  context 'single chapter, single verse, Song of Solomon' do
    let(:citation_text) { 'Song of Solomon 1:1' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Song of Solomon', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, starter: nil, terminator: nil
          }]
        }]
      })
    end
  end

  context 'single chapter, verse range' do
    let(:citation_text) { 'Genesis 1:1-5' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 5, starter: nil, terminator: nil
          }]
        }]
      })
    end
  end

  context 'single chapter, verse range, starter fragment' do
    let(:citation_text) { 'Genesis 1:1-5 God' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 5, terminator: nil, starter: {
              fragment: 'God', cardinality: 1
            }
          }]
        }]
      })
    end
  end

  context 'single chapter, verse range, starter fragment with cardinality' do
    let(:citation_text) { 'Genesis 1:1-5 2nd God' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 5, terminator: nil, starter: {
              fragment: 'God', cardinality: 2
            }
          }]
        }]
      })
    end
  end

  context 'single chapter, single verse, starter fragment with cardinality' do
    let(:citation_text) { 'Genesis 1:1 2nd God' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, terminator: nil, starter: {
              fragment: 'God', cardinality: 2
            }
          }]
        }]
      })
    end
  end

  context 'single chapter, single verse, starter fragment, terminator fragment' do
    let(:citation_text) { 'Genesis 1:1 God (to said)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, terminator: {
              fragment: 'said', cardinality: 1
            }, starter: {
              fragment: 'God', cardinality: 1
            }
          }]
        }]
      })
    end
  end

  context 'single chapter, single verse, starter fragment, terminator fragment with cardinality' do
    let(:citation_text) { 'Genesis 1:1 God (to 2nd said)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, terminator: {
              fragment: 'said', cardinality: 2
            }, starter: {
              fragment: 'God', cardinality: 1
            }
          }]
        }]
      })
    end
  end

  context 'single chapter, single verse, starter fragment with cardinality, terminator fragment with cardinality' do
    let(:citation_text) { 'Genesis 1:1 3rd God (to 2nd said)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, terminator: {
              fragment: 'said', cardinality: 2
            }, starter: {
              fragment: 'God', cardinality: 3
            }
          }]
        }]
      })
    end
  end

  context 'multiple chapters, single verse' do
    let(:citation_text) { 'Genesis 1:1; 4:8' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, terminator: nil, starter: nil
          }]
        }, {
          chapter_number: 4, verses: [{
            start: 8, finish: 8, terminator: nil, starter: nil
          }]
        }]
      })
    end
  end

  context 'multiple chapters, single and multiple verses' do
    let(:citation_text) { 'Genesis 1:1; 4:8, 9-12' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, terminator: nil, starter: nil
          }]
        }, {
          chapter_number: 4, verses: [{
            start: 8, finish: 8, terminator: nil, starter: nil
          }, {
            start: 9, finish: 12, terminator: nil, starter: nil
          }]
        }]
      })
    end
  end

  context 'multiple chapters, verses with terminators' do
    let(:citation_text) { 'Genesis 1:1; 4:8 great (to 2nd ;), 9-12 2nd not (to 3rd ,)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        book: 'Genesis', chapters: [{
          chapter_number: 1, verses: [{
            start: 1, finish: 1, terminator: nil, starter: nil
          }]
        }, {
          chapter_number: 4, verses: [{
            start: 8, finish: 8, terminator: {
              fragment: ';', cardinality: 2
            }, starter: {
              fragment: 'great', cardinality: 1
            }
          }, {
            start: 9, finish: 12, terminator: {
              fragment: ',', cardinality: 3
            }, starter: {
              fragment: 'not', cardinality: 2
            }
          }]
        }]
      })
    end
  end
end
