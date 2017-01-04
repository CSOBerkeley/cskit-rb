# encoding: UTF-8

module CSKit
  module Formatters
    module Bible
      class BibleJsonFormatter < CSKit::Formatters::Formatter

        def format_readings(readings)
          readings.map do |reading|
            reading.to_hash
          end
        end

      end
    end
  end
end
