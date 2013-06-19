# encoding: UTF-8

module CSKit
  module Parsers
    module Bible

      Citation = Struct.new(:book, :chapter_list) do
        def to_s
          "#{book.strip} #{chapter_list.map(&:to_s).join("; ")}"
        end

        def to_hash
          {
            :book => book,
            :chapters => chapter_list.map(&:to_hash)
          }
        end
      end

      Chapter = Struct.new(:chapter_number, :verse_list) do
        def to_s
          "#{chapter_number}:#{verse_list.map(&:to_s).join(", ")}"
        end

        def to_hash
          {
            :chapter_number => chapter_number,
            :verses => verse_list.map(&:to_hash)
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
            :start => start,
            :finish => finish,
            :starter => starter ? starter.to_hash : nil,
            :terminator => terminator ? terminator.to_hash : nil
          }
        end
      end

      Positional = Struct.new(:cardinality, :fragment) do
        def to_s
          card_s = case cardinality
            when 1 then "1st"
            when 2 then "2nd"
            when 3 then "3rd"
          end

          if cardinality
            "#{card_s} #{fragment}"
          else
            fragment
          end
        end

        def to_hash
          {
            :cardinality => cardinality,
            :fragment => fragment
          }
        end
      end

    end
  end
end