# encoding: UTF-8

module CSKit
  module Parsers
    module ScienceHealth

      class ScienceHealthTokenizer < CSKit::Parsers::Tokenizer
        PATTERNS = {
          left_paren:  /\A\(/,
          right_paren: /\A\)/,
          dash:        /\A-/,
          colon:       /\A:/,
          comma:       /\A,/,
          to:          /\Ato/,
          only:        /\Aonly(?=\))/,
          cardinality: /\A(1st|2nd|3rd|4th)/,
          page_number: /\A(vii|viii|ix|x|xi|xii)(?=:)/,  # must precede a colon
          number:      /\A\d+/,
          text:        /\A[^\s\(\):,]+/,
          space:       /\A[\s\t]+/
        }

        private

        def patterns
          PATTERNS
        end
      end

    end
  end
end

