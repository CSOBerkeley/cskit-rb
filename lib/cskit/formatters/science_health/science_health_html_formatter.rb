# encoding: UTF-8

module CSKit
  module Formatters
    module ScienceHealth
      class ScienceHealthHtmlFormatter < ScienceHealthPlainTextFormatter

        # _word_
        ITALICS_REGEX = /_([a-zA-Z0-9\-\.,\"\'\?]+)_/

        protected

        def format_lines(lines, citation_line)
          detect_italics(super)
        end

        def detect_italics(lines)
          lines.map do |line|
            line.gsub(ITALICS_REGEX) do |match|
              "<em>#{$1}</em>"
            end
          end
        end

        def separator
          options[:separator] || "<br />"
        end

      end
    end
  end
end