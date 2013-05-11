# encoding: UTF-8

require 'json'

module CSKit
  module Lesson
    class Lesson

      attr_reader :sections

      class << self
        def from_file(file)
          ext = File.extname(file)[1..-1]
          send(:"from_#{ext}", File.read(file))
        end

        def from_json(data)
          sections = JSON.parse(data).map do |section_data|
            Section.new(
              section_data["section"],
              section_data["readings"].inject({}) do |ret, (k, v)|
                ret[k.to_sym] = v; ret
              end
            )
          end

          new(sections)
        end
      end

      def initialize(sections)
        @sections = sections
      end

    end
  end
end