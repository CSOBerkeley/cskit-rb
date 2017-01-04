# encoding: UTF-8

module CSKit
  module Parsers
    # base class for tokenizers
    class Tokenizer
      attr_reader :citation

      def initialize(citation)
        @citation = citation
      end

      def each_token
        return to_enum(__method__) unless block_given?

        text = citation.dup
        pos = 0

        until text.empty?
          patterns.each_pair do |token_type, pattern|
            if match = pattern.match(text)
              unless token_type == :space
                yield Token.new(token_type, match[0], pos)
              end

              text[0...match[0].size] = ''
              pos += match[0].size

              break
            end
          end
        end
      end

      private

      def patterns
        raise NotImplementedError,
          "`#{__method__}' must be implemented by derived classes"
      end
    end
  end
end
