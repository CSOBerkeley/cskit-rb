# encoding: UTF-8

require 'spec_helper'

include CSKit::Parsers::ScienceHealth

describe ScienceHealthParser do
  let(:parser) { described_class.new(citation_text) }

  context 'single page, single line' do
    let(:citation_text) { '35:19' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 19, starter: nil, terminator: nil
        }]
      })
    end
  end

  context 'single page, multiple lines' do
    let(:citation_text) { '35:19-21' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, starter: nil, terminator: nil
        }]
      })
    end
  end

  context 'single page, multiple lines, starter fragment' do
    let(:citation_text) { '35:19-21 and' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, terminator: nil, starter: {
            fragment: 'and', cardinality: 1
          }
        }]
      })
    end
  end

  context 'single page, multiple lines, starter fragment with cardinality' do
    let(:citation_text) { '35:19-21 2nd and' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, terminator: nil, starter: {
            fragment: 'and', cardinality: 2
          }
        }]
      })
    end
  end

  context 'single page, multiple lines, starter fragment, terminator fragment' do
    let(:citation_text) { '35:19-21 and (to .)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, terminator: {
            fragment: '.', cardinality: 1
          }, starter: {
            fragment: 'and', cardinality: 1
          }
        }]
      })
    end
  end

  context 'single page, multiple lines, starter fragment, terminator fragment with cardinality' do
    let(:citation_text) { '35:19-21 and (to 3rd .)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, terminator: {
            fragment: '.', cardinality: 3
          }, starter: {
            fragment: 'and', cardinality: 1
          }
        }]
      })
    end
  end

  context 'single page, multiple lines, starter fragment with cardinality, terminator fragment with cardinality' do
    let(:citation_text) { '35:19-21 2nd and (to 3rd .)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, terminator: {
            fragment: '.', cardinality: 3
          }, starter: {
            fragment: 'and', cardinality: 2
          }
        }]
      })
    end
  end

  context 'single page, multiple lines, starter fragment, terminator fragment with only' do
    let(:citation_text) { '35:19-21 and (only)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, terminator: {
            only: true
          }, starter: {
            fragment: 'and', cardinality: 1
          }
        }]
      })
    end
  end

  context 'single page, multiple lines, terminator fragment with only' do
    let(:citation_text) { '35:19-21 (only)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 21, starter: nil, terminator: {
            only: true
          }
        }]
      })
    end
  end

  context 'single page, terminator fragment with only' do
    let(:citation_text) { '35:19 (only)' }

    it 'parses correctly' do
      expect(parser.parse.to_hash).to eq({
        page: '35', lines: [{
          start: 19, finish: 19, starter: nil, terminator: {
            only: true
          }
        }]
      })
    end
  end
end
