# encoding: UTF-8

module CSKit
  module Parsers
    module Bible

      class CitationNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[:book, book.to_sexp], [:chapter, chapter.to_sexp], [:verses, verse_list.to_sexp]]
        end

        def to_object
          CSKit::Parsers::Bible::Citation.new(
            book.text_value,
            chapter.text_value.to_i,
            verse_list.to_object
          )
        end
      end

      class BookNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          text_value
        end
      end

      class ChapterNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          text_value.to_i
        end
      end

      class VerseListNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          result = [verse.to_sexp]

          if elements[1] && elements[1].respond_to?(:verse_list)
            result += elements[1].verse_list.to_sexp
          end

          result
        end

        def to_object
          result = [verse.to_object]

          if elements[1] && elements[1].respond_to?(:verse_list)
            result += elements[1].verse_list.to_object
          end

          result
        end
      end

      class VerseNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          elements.flat_map { |e| e.to_sexp if e.respond_to?(:to_sexp) }
        end

        def to_object
          line_numbers = elements[0].to_sexp.first

          CSKit::Parsers::Bible::Verse.new(
            line_numbers.first,
            line_numbers.last,
            (start_fragment.value rescue nil),
            (terminator.to_object rescue nil)
          )
        end
      end

      class CompoundVerseNumberNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[verse_number1.text_value.to_i, verse_number2.text_value.to_i]]
        end
      end

      class VerseNumberNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[text_value.to_i, text_value.to_i]]
        end
      end

      class TerminatorNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [get_cardinality, fragment.text_value]
        end

        def get_cardinality
          card_val = cardinality.text_value.to_i
          card_val == 0 ? 1 : card_val
        end

        def to_object
          Terminator.new(get_cardinality, fragment.text_value)
        end
      end

      class FragmentNode < Treetop::Runtime::SyntaxNode
        def value
          text_value.strip
        end

        alias :to_sexp :value
      end

    end
  end
end