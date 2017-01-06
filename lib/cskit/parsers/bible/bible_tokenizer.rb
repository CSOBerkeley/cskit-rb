# encoding: UTF-8

module CSKit
  module Parsers
    module Bible

      class BibleTokenizer < CSKit::Parsers::Tokenizer
        PATTERNS = {
          book:        /\Ai{1,3}\s+[^\s\(\);:,]+/i,
          sos:         /\Asong\s+of\s+solomon/i,
          left_paren:  /\A\(/,
          right_paren: /\A\)/,
          dash:        /\A-/,
          colon:       /\A:/,
          semicolon:   /\A;/,
          comma:       /\A,/,
          to:          /\Ato/,
          cardinality: /\A(1st|2nd|3rd|4th)/,
          number:      /\A\d+/,
          text:        /\A[^\s\(\);:,]+/,
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

