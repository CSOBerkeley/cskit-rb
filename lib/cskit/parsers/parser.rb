# encoding: UTF-8

module CSKit
  module Parsers
    class ParserError < StandardError; end

    class Parser
      def initialize(citation_text)
        @citation_text = citation_text
        @token_stream = get_token_stream
        @current = token_stream.next
      end

      def parse
        result = entry_point

        unless eos?
          raise ParserError, "Expected end of input but more input is available "\
            "at position #{current.position}"
        end

        result
      end

      def entry_point
        raise NotImplementedError,
          "`#{__method__} must be defined in derived classes"
      end

      private

      def get_token_stream
        raise NotImplementedError,
          "`#{__method__} must be defined in derived classes"
      end

      attr_reader :citation_text, :token_stream, :current

      def eos?
        token_stream.peek
        false
      rescue StopIteration
        true
      end

      def eos_token
        @eos_token ||= Token.new(:eos, nil, citation_text.size)
      end

      def next_token(*token_types)
        if !token_types.include?(current.type)
          raise ParserError, "Expected #{token_types.join(', ')} but got "\
            "#{current.type} ('#{current.value}') at position #{current.position}"
        end

        if eos?
          if current.type == :eos
            raise(ParserError, 'Unexpected end of input')
          else
            @current = eos_token
          end
        else
          @current = token_stream.next
        end
      end
    end
  end
end
