# encoding: UTF-8

module CSKit
  module Parsers
    module ScienceHealth

      DEFAULT_CARDINALITY = 1

      Citation = Struct.new(:page, :lines) do
        def to_s
          "#{page}:#{lines.map(&:to_s).join(", ")}"
        end

        def to_hash
          {
            page: page,
            lines: lines.map(&:to_hash)
          }
        end
      end

      Line = Struct.new(:start, :finish, :starter, :terminator) do
        def to_s
          str = if finish
            "#{start}-#{finish}"
          else
            start.to_s
          end

          str << ' (only)' if only?
          str << " #{start_fragment}" if start_fragment
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

      class Positional
        attr_reader :cardinality, :fragment

        def initialize(cardinality, fragment)
          @cardinality = cardinality
          @fragment = fragment
        end

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

      class Starter < Positional
      end

      class FragmentTerminator < Positional
      end

      class OnlyTerminator
        def self.instance
          @instance ||= send(:new)
        end

        def to_hash
          { only: true }
        end

        private def initialize
        end
      end


      class ScienceHealthParser < CSKit::Parsers::Parser
        def entry_point
          page
        end

        private

        def get_token_stream
          ScienceHealthTokenizer.new(citation_text).each_token.lazy
        end

        def page
          page_num = page_number
          next_token(:colon)
          llist = line_list

          Citation.new(page_num, llist)
        end

        def page_number
          current.value.tap { next_token(:page_number, :number) }
        end

        def line_list
          [].tap do |list|
            loop do
              list << line

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

        def line
          start = current.value.tap { next_token(:number) }.to_i
          finish = start
          starter = nil

          if current.type == :dash
            next_token(:dash)
            finish = current.value.tap { next_token(:number) }.to_i
          end

          starter = line_starter
          terminator = line_terminator

          Line.new(start, finish, starter, terminator)
        end

        def line_starter
          case current.type
            when :text, :cardinality
              card = cardinality
              fragment = current.value
              next_token(:text, :colon, :comma)
              Starter.new(card, fragment)
          end
        end

        def line_terminator
          if current.type == :left_paren
            next_token(:left_paren)

            terminator = if current.type == :to
              fragment_terminator
            else
              only_terminator
            end

            next_token(:right_paren)
            terminator
          end
        end

        def fragment_terminator
          next_token(:to)

          card = cardinality
          fragment = current.value
          next_token(:text, :colon, :comma)

          FragmentTerminator.new(card, fragment)
        end

        def only_terminator
          next_token(:only)
          OnlyTerminator.instance
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
