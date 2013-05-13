# encoding: UTF-8

module CSKit
  module Formatters
    module Bible
      class BiblePlainTextFormatter

        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        def format_readings(readings)
          join(
            readings.map do |reading|
              format_verse_texts(
                reading.texts,
                reading.citation
              )
            end
          )
        end

        def join(texts)
          texts.join(separator)
        end

        protected

        def format_verse_texts(texts, verse)
          join(
            texts.each_with_index.map do |text, index|
              text = format_starter(text, verse.starter) if index == 0
              text = format_terminator(text, verse.terminator) if index == texts.size - 1
              verse_number = verse.start + index
              include_verse_number? ? "#{verse_number} #{text}" : text
            end
          )
        end

        def format_starter(text, starter)
          if starter
            regex = /\s+#{starter.fragment}([\s,\.\-_\?\!\.;:]|$)/
            begin_pos = find_position(text, regex, starter.cardinality)
            begin_pos ? "..." + text[begin_pos..-1].strip : text.strip
          else
            text
          end
        end

        def format_terminator(text, terminator)
          if terminator
            regex = /#{Regexp.escape(terminator.fragment)}/
            stop_pos = find_position(text, regex, terminator.cardinality)
            text[0..stop_pos]
          else
            text
          end
        end

        def find_position(text, regex, cardinality)
          (0...cardinality).inject(-1) do |last_index, _|
            return nil unless last_index
            text.index(regex, last_index + 1)
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