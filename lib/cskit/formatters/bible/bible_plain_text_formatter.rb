# encoding: UTF-8

module CSKit
  module Formatters
    module Bible
      class BiblePlainTextFormatter < CSKit::Formatters::Formatter

        def format_readings(readings)
          join_readings(readings) do |reading|
            format_reading(reading)
          end
        end

        def format_annotated_readings(readings, annotation_formatter)
          join_readings(readings) do |reading|
            format_annotated_reading(reading, annotation_formatter)
          end
        end

        def join(texts)
          texts.join(separator)
        end

        private

        def join_readings(readings)
          join(
            readings.map do |reading|
              join(yield(reading))
            end
          )
        end

        def format_annotated_reading(reading, annotation_formatter)
          reading.texts.each_with_index.map do |text, index|
            starter_pos = starter_position(text, reading.verse.starter)
            terminator_pos = terminator_position(text, reading.verse.terminator)

            annotated_str = CSKit::AnnotatedString.new(text, reading.annotations_at(index))
            annotated_str.delete(terminator_pos + 1, text.length - (terminator_pos + 1)) if terminator_pos
            annotated_str.delete(0, starter_pos) if starter_pos

            text = annotated_str.render do |snippet, annotation|
              annotation_formatter.format_annotation(annotation, snippet)
            end

            verse_number = reading.verse.start + index
            attach_verse_number(verse_number, text)
          end
        end

        def format_reading(reading)
          reading.texts.each_with_index.map do |text, index|
            if index == 0
              pos = starter_position(text, reading.verse.starter)
              text = format_starter(pos ? text[pos..-1].strip : text.strip, pos)
            end

            if index == reading.texts.size - 1
              pos = terminator_position(text, reading.verse.terminator)
              text = format_terminator(pos ? text[0..pos] : text, pos)
            end

            verse_number = reading.verse.start + index
            attach_verse_number(verse_number, text)
          end
        end

        def attach_verse_number(verse_number, text)
          include_verse_number? ? "#{verse_number} #{text}" : text
        end

        def starter_position(text, starter)
          if starter
            regex = /\s+#{starter.fragment}([\s,\.\-_\?\!\.;:]|$)/
            find_position(text, regex, starter.cardinality)
          end
        end

        def format_starter(text, pos)
          pos ? '...' + text : text
        end

        def terminator_position(text, terminator)
          if terminator
            regex = /#{Regexp.escape(terminator.fragment)}/
            find_position(text, regex, terminator.cardinality)
          end
        end

        def format_terminator(text, pos)
          text
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
