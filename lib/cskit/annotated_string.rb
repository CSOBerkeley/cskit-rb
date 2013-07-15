# encoding: UTF-8

module CSKit
  class AnnotatedString

    attr_reader :string
    attr_reader :annotations

    def initialize(string, annotations = [])
      @string = string
      @annotations = annotations
    end

    def add_annotation(annotation)
      annotations << annotation
    end

    def render
      each_chunk.map do |text, annotation|
        if annotation
          yield text, annotation
        else
          text
        end
      end.join
    end

    def delete(pos, length)
      new_length = string.length - length

      annotations.reject! do |annotation|
        reject = annotation.start >= new_length || annotation.finish >= new_length

        if annotation.start >= pos
          annotation.start -= length
          annotation.finish -= length
        end

        reject || (annotation.start < 0 || annotation.finish < 0)
      end

      @string = @string[0...pos] + @string[(pos + length)..-1]
    end

    private

    def each_chunk(&block)
      enum = Enumerator.new do |yielder|
        last = 0
        sorted_annotations.each do |annotation|
          starter = string[last...annotation.start]
          yielder.yield(starter, nil) unless starter.empty?

          middle = string[annotation.start..annotation.finish]
          yielder.yield(middle, annotation)
          last = annotation.finish + 1
        end

        terminator = string[last..-1]
        yielder.yield(terminator, nil) unless terminator.empty?
      end

      block_given? ? enum.each(&block) : enum
    end

    def sorted_annotations
      annotations.sort do |a, b|
        a.start <=> b.start
      end
    end

  end
end