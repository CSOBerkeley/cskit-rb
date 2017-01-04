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
              section_data['section'],
              section_data['readings'].inject({}) do |ret, (k, v)|
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

      def each_reading(volumes)
        sections.each do |section|
          volumes.each do |volume|
            section.each_reading_group_for(volume) do |readings, citation|
              yield section, citation, volume, readings
            end
          end
        end
      end

      def each_formatted_reading(formatters)
        each_reading(formatters.keys) do |section, citation, volume, readings|
          formatter = formatters[volume]
          yield section, citation, volume, formatter.format_readings(readings)
        end
      end

      def each_formatted_section(formatters)
        last_section = nil
        current_texts = nil

        each_formatted_reading(formatters) do |section, citation, volume, text|
          if section.name != (last_section.name rescue nil)
            yield section, current_texts if current_texts
            current_texts = {}
          end

          last_section = section
          formatter = formatters[volume]
          current_texts[volume] = formatter.join([current_texts[volume], text])
        end

        yield last_section, current_texts if current_texts
      end

    end
  end
end
