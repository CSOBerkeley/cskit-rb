# encoding: UTF-8

module CSKit
  module Formatters
    module ScienceHealth
      class ScienceHealthPlainTextFormatter

        attr_reader :options

        # semicolon, question mark, or period
        SENTENCE_TERMINATOR_REGEX = /[;\?\.]/

        # either a period + space, quotes, or start of line followed by the first capital letter or number.
        SENTENCE_START_REGEX = /(\.\s+|\.\"\s+|\.\'\s+|^)[A-Z0-9\"\']/

        def initialize(options = {})
          @options = options
        end

        def format_readings(readings)
          join(
            readings.map do |reading|
              format_lines(reading.texts, reading.citation)
            end
          )
        end

        def join(texts)
          texts.join(separator)
        end

        protected

        def format_lines(lines, citation_line)
          lines.each_with_index.map do |line, line_index|
            line_text = line.text

            line_text = if line_index == 0
              if citation_line.start_fragment
                index = line_text.index(citation_line.start_fragment)
                index ? line_text[index..-1] : line_text
              else
                matches = line_text.match(SENTENCE_START_REGEX)
                if matches && matches.length == 2
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

        def separator
          options[:separator] || "\n"
        end

      end
    end
  end
end