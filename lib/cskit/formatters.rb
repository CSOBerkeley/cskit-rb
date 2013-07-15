# encoding: UTF-8

module CSKit
  module Formatters

    autoload :Bible,         "cskit/formatters/bible"
    autoload :ScienceHealth, "cskit/formatters/science_health"


    class Formatter
      attr_reader :options

      def initialize(options = {})
        @options = options
      end
    end

  end
end