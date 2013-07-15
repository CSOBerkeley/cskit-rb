# encoding: UTF-8

module CSKit
  module Readers

    Reading = Struct.new(:texts, :citation, :chapter, :verse) do
      def params
        @params || {}
      end

      def to_annotated_reading
        AnnotatedReading.new(texts, citation, chapter, verse)
      end

      def annotated?
        false
      end
    end

    class AnnotatedReading < Reading
      def add_annotation(text_index, annotation)
        (annotations[text_index] ||= []) << annotation
      end

      def annotations_at(index)
        annotations[index]
      end

      def annotations
        @annotations ||= {}
      end

      def annotated?
        true
      end
    end

  end
end