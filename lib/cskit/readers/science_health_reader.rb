# encoding: UTF-8

module CSKit
  module Readers
    class ScienceHealthReader
      NUMERALS = %w(vi vii ix x xi xii)

      attr_reader :volume

      Paragraph = Struct.new(
        :lines, :line_start, :line_end, :page_start, :page_end
      )

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
          line_number, page_number = increment(line_number, page_number)
        end
      rescue Errno::ENOENT => e
      end

      # be careful - this will go all the way to the end of the book unless you break
      def each_paragraph(line_number, page_number)
        while paragraph = get_paragraph(page_number, line_number)
          yield paragraph
          line_number, page_number = increment(
            paragraph.line_end, paragraph.page_end
          )
        end
      rescue Errno::ENOENT => e
      end

      def get_paragraph(page_number, line_number)
        original_page_number = page_number
        original_line_number = line_number
        first_line = true
        lines = []

        each_line(line_number, page_number) do |cur_line, cur_line_number, cur_page_number|
          if first_line
            lines << cur_line
          else
            if cur_line.paragraph_start? && !first_line
              break
            else
              lines << cur_line
            end
          end

          first_line = false
          line_number = cur_line_number
          page_number = cur_page_number
        end

        Paragraph.new(
          lines, original_line_number, line_number,
          original_page_number, page_number
        )
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
          lines = if citation_line.start == citation_line.finish
            if citation_line.only?
              [get_line(citation_line.start, citation.page)]
            else
              get_paragraph(citation.page, citation_line.start).lines
            end
          else
            get_line_range(citation_line.start..citation_line.finish, citation.page)
          end

          Reading.new(lines, citation_line)
        end
      end

      private

      def increment(line_number, page_number)
        page = get_page(page_number)
        if (line_number + 1) > page.lines.size
          [1, next_page_number(page_number)]
        else
          [line_number + 1, page_number]
        end
      end

      def next_page_number(page_number)
        if index = NUMERALS.index(page_number)
          if index == NUMERALS.size - 1
            '1'
          else
            NUMERALS[index + 1]
          end
        else
          if page_number == '497'
            '501'
          else
            (page_number.to_i + 1).to_s
          end
        end
      end

    end
  end
end
