# encoding: UTF-8

include CSKit::Books::ScienceHealth

module CSKit
  module Readers
    class ScienceHealthReader

      # semicolon, question mark, or period
      SENTENCE_TERMINATOR_REGEX = /[;\?\.]/

      # either a period + space or start of line followed by the first capital letter or number.
      SENTENCE_START_REGEX = /(\.\s+|^)[A-Z0-9]/

      attr_reader :resource_path

      def initialize(resource_path)
        @resource_path = resource_path
      end

      def get_page(page_number)
        resource_file = File.join(resource_path, "#{page_number}.json")
        page_cache[page_number] ||= Page.from_hash(JSON.parse(File.read(resource_file)))
      end

      def get_line(line_number, page_number)
        get_page(page_number).lines[line_number - 1]
      end

      # be careful - this will go all the way to the end of the book unless you break
      def each_line(line_number, page_number)
        while page = get_page(page_number)
          yield get_line(line_number, page_number)

          line_number, page_number = if (line_number + 1) > page.lines.size
            [1, page_number + 1]
          else
            [line_number + 1, page_number]
          end
        end
      end

      def get_paragraph(page_number, line_number)
        first_line = true
        lines = []

        each_line(line_number, page_number) do |line|
          if first_line
            lines << line
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
        range.map do |line_number|
          get_line(line_number, page_number)
        end
      end

      def text_for(citation)
        citation.lines.inject("") do |ret, citation_line|
          lines = if citation_line.finish
            get_line_range(citation_line.start..citation_line.finish, citation.page)
          else
            if citation_line.only?
              [get_line(citation_line.start, citation.page)]
            else
              get_paragraph(citation.page, citation_line.start)
            end
          end

          ret << format_lines(lines, citation_line).join("\n")
        end
      end

      protected

      # @TODO: extract this functionality into a Formatter class.
      # Formatting should not be the Reader's responsibility
      def format_lines(lines, citation_line)
        lines.each_with_index.map do |line, line_index|
          line_text = line.text

          line_text = if line_index == 0
            if citation_line.start_fragment
              index = line_text.index(citation_line.start_fragment)
              index ? line_text[index..-1] : line_text
            else
              matches = line_text.match(SENTENCE_START_REGEX)
              if matches.length == 2
                offset = matches.offset(1)
                spaces = " " * offset.first  # indent to match physical position in S&H book
                spaces + line_text[matches.offset(1).last..-1]
              else
                line_text
              end
            end
          else
            line_text
          end

          line_text = if line_index == (lines.size - 1)
            index = line_text.index(SENTENCE_TERMINATOR_REGEX)
            index ? line_text[0..index] : line_text
          else
            line_text
          end

          # indent start of paragraph
          if line.paragraph_start?
            "   #{line_text}"
          else
            line_text
          end
        end
      end

      def page_cache
        @page_cache ||= {}
      end

    end
  end
end
