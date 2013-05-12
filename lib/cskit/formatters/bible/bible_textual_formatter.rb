# encoding: UTF-8

module CSKit
  module Formatters
    module Bible
      class BibleTextualFormatter

        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        def format_readings(readings)
          readings.map do |reading|
            format_verse_texts(
              reading.texts,
              reading.citation
            )
          end.join(separator)
        end

        protected

        def format_verse_texts(texts, verse)
          texts.each_with_index.map do |text, index|
            text = format_start_fragment(text, verse.start_fragment) if index == 0
            text = format_terminator(text, verse.terminator) if index == texts.size - 1
            verse_number = verse.start + index
            include_verse_number? ? "#{verse_number} #{text}" : text
          end.join(separator)
        end

        def format_start_fragment(text, start_fragment)
          if start_fragment
            idx = text.index(/\s+#{start_fragment}([\s,\.\-_\?\!\.;:]|$)/)
            idx ? "..." + text[idx..-1].strip : text.strip
          else
            text
          end
        end

        def format_terminator(text, terminator)
          if terminator
            stop_pos = (0...terminator.cardinality).inject(-1) do |last_index, _|
              text.index(terminator.fragment, last_index + 1)
            end

            text[0..stop_pos]
          else
            text
          end
        end

        def separator
          options[:separator] || " "
        end

        def include_verse_number?
          if options[:include_verse_number].nil?
            true  # default
          else
            !!options[:include_verse_number]
          end
        end

      end
    end
  end
end