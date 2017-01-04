# encoding: UTF-8

module CSKit
  module Parsers
    module Bible

      DEFAULT_CARDINALITY = 1

      Citation = Struct.new(:book, :chapter_list) do
        def to_s
          "#{book} #{chapter_list.map(&:to_s).join('; ')}"
        end

        def to_hash
          {
            book: book,
            chapters: chapter_list.map(&:to_hash)
          }
        end
      end

      Chapter = Struct.new(:chapter_number, :verse_list) do
        def to_s
          "#{chapter_number}:#{verse_list.map(&:to_s).join(', ')}"
        end

        def to_hash
          {
            chapter_number: chapter_number,
            verses: verse_list.map(&:to_hash)
          }
        end
      end

      Verse = Struct.new(:start, :finish, :starter, :terminator) do
        def to_s
          str = if start == finish
            start.to_s
          else
            "#{start}-#{finish}"
          end

          str << " #{starter}" if starter
          str << " (to #{terminator})" if terminator
          str
        end

        def to_hash
          {
            start: start,
            finish: finish,
            starter: starter ? starter.to_hash : nil,
            terminator: terminator ? terminator.to_hash : nil
          }
        end
      end

      Positional = Struct.new(:cardinality, :fragment) do
        def to_s
          card_s = case cardinality
            when 1 then '1st'
            when 2 then '2nd'
            when 3 then '3rd'
          end

          if cardinality
            "#{card_s} #{fragment}"
          else
            fragment
          end
        end

        def to_hash
          {
            cardinality: cardinality,
            fragment: fragment
          }
        end
      end


      class BibleParser < CSKit::Parsers::Parser
        def entry_point
          Citation.new(book, chapter_list)
        end

        private

        def get_token_stream
          BibleTokenizer.new(citation_text).each_token.lazy
        end

        def book
          current.value.tap { next_token(:text) }
        end

        def chapter_list
          [].tap do |list|
            loop do
              list << chapter

              case current.type
                when :semicolon
                  next_token(:semicolon)
                else
                  break
              end

              break if eos?
            end
          end
        end

        def chapter
          chap_num = chapter_number
          next_token(:colon)
          vlist = verse_list

          Chapter.new(chap_num, vlist)
        end

        def chapter_number
          current.value.tap { next_token(:number) }.to_i
        end

        def verse_list
          [].tap do |list|
            loop do
              list << verse

              case current.type
                when :comma
                  next_token(:comma)
                else
                  break
              end

              break if eos?
            end
          end
        end

        def verse
          start = current.value.tap { next_token(:number) }.to_i
          finish = start
          starter = nil

          if current.type == :dash
            next_token(:dash)
            finish = current.value.tap { next_token(:number) }.to_i
          end

          starter = verse_starter
          terminator = verse_terminator

          Verse.new(start, finish, starter, terminator)
        end

        def verse_starter
          case current.type
            when :text, :cardinality
              positional
          end
        end

        def verse_terminator
          if current.type == :left_paren
            next_token(:left_paren)
            next_token(:to)
            positional.tap { next_token(:right_paren) }
          end
        end

        def positional
          card = cardinality
          fragment = current.value
          next_token(:text, :semicolon, :colon, :comma)
          Positional.new(card, fragment)
        end

        def cardinality
          if current.type == :cardinality
            current.value.tap { next_token(:cardinality) }.to_i
          else
            DEFAULT_CARDINALITY
          end
        end
      end

    end
  end
end
