# encoding: UTF-8

module CSKit
  module Lesson
    class Section

      attr_reader :name, :citation_texts

      def initialize(name, citation_texts)
        @name = name
        @citation_texts = citation_texts
      end

      def each_reading_group_for(volume_name)
        volume_name = volume_name.to_sym
        volume = CSKit.get_volume(volume_name)

        citation_texts[volume_name].each do |citation_text|
          citation = volume.parse_citation(citation_text)
          yield volume.readings_for(citation), citation
        end
      end

    end
  end
end