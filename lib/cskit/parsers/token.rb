# encoding: UTF-8

module CSKit
  module Parsers

    class Token
      attr_reader :type, :value, :position

      def initialize(type, value, position)
        @type = type
        @value = value
        @position = position
      end
    end

  end
end
