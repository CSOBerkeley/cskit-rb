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
        if idx = index(text_index, annotation)
          annotations[text_index].delete_at(idx)
        end

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

      private

      def index(text_index, annotation_to_find)
        (annotations[text_index] || []).each_with_index do |annotation, index|
          if annotation.start == annotation_to_find.start && annotation.finish == annotation_to_find.finish
            return index
          end
        end
        nil
      end
    end

  end
end