# encoding: UTF-8

module CSKit
  module Formatters
    module Bible
      class BibleHtmlFormatter < BiblePlainTextFormatter

        protected

        def format_verse_texts(texts, verse)
          texts.each_with_index.map do |text, index|
            if index == 0
              pos = starter_position(text, verse.starter)
              text = format_starter(text, pos)
            end

            if index == texts.size - 1
              pos = terminator_position(text, verse.terminator)
              text = format_terminator(text, pos)
            end

            verse_number = verse.start + index
            verse_number = wrap_verse_number(verse_number)
            text = wrap_text(text)

            include_verse_number? ? "#{verse_number} #{text}" : text
          end
        end

        def wrap_text(text)
          "<span class='cskit-verse-text>#{text}</span>"
        end

        def wrap_verse_number(verse_number)
          "<span class='cskit-verse-number'>#{verse_number}</span>"
        end

      end
    end
  end
end