module CSKit
  module Parsers
    module Bible

      class CitationNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[:book, book.to_sexp], [:chapter, chapter.to_sexp], [:verses, verse_list.to_sexp]]
        end

        def to_object
          CSKit::Parsers::ScienceHealth::Citation.new(
            page.text_value,
            line_list.to_object
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
      end

      class VerseNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          elements.flat_map { |e| e.to_sexp if e.respond_to?(:to_sexp) }
        end
      end

      class CompoundVerseNumberNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[verse_number1.text_value.to_i, verse_number2.text_value.to_i]]
        end
      end

      class VerseNumberNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[text_value.to_i, nil]]
        end
      end

      class ToNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [cardinality.text_value.to_i, fragment.text_value]
        end
      end

      class FragmentNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          text_value.strip
        end
      end

    end
  end
end