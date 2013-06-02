# encoding: UTF-8

module CSKit
  module Readers
    class ScienceHealthReader

      attr_reader :volume

      def initialize(volume)
        @volume = volume
      end

      def get_page(page_number)
        volume.get_page(page_number)
      end

      def get_line(line_number, page_number)
        get_page(page_number).lines[line_number - 1]
      end

      # be careful - this will go all the way to the end of the book unless you break
      def each_line(line_number, page_number)
        while page = get_page(page_number)
          yield get_line(line_number, page_number), line_number, page_number

          line_number, page_number = if (line_number + 1) > page.lines.size
            [1, next_page_number(page_number)]
          else
            [line_number + 1, page_number]
          end
        end
      end

      def get_paragraph(page_number, line_number)
        first_line = true
        lines = []

        each_line(line_number, page_number) do |line, line_number, page_number|
          if first_line
            lines << line_text
          else
            if line.paragraph_start? && !first_line
              break
            else
              lines << line
            end
          end

          first_line = false
        end

        lines
      end

      def get_line_range(range, page_number)
        lines = []
        each_line(range.first, page_number) do |line, line_number, page_number|
          lines << line
          break if line_number == range.last
        end
        lines
      end

      def readings_for(citation)
        citation.lines.map do |citation_line|
          lines = if citation_line.finish
            get_line_range(citation_line.start..citation_line.finish, citation.page)
          else
            if citation_line.only?
              [get_line(citation_line.start, citation.page)]
            else
              get_paragraph(citation.page, citation_line.start)
            end
          end

          Reading.new(lines, citation_line)
        end
      end

      protected

      def next_page_number(page_number)
        numerals = ["vi", "vii", "ix", "x", "xi", "xii"]
        if index = numerals.index(page_number)
          if index == numerals.size - 1
            "1"
          else
            numerals[index + 1]
          end
        else
          (page_number.to_i + 1).to_s
        end
      end

    end
  end
end
