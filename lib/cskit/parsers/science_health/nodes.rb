# encoding: UTF-8

module CSKit
  module Parsers
    module ScienceHealth

      class CitationNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[:page, page.to_sexp], [:lines, line_list.to_sexp]]
        end

        def to_object
          CSKit::Parsers::ScienceHealth::Citation.new(
            page.text_value,
            line_list.to_object
          )
        end
      end

      class PageNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          text_value
        end
      end

      class LineListNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          result = [line.to_sexp]

          if elements[1] && elements[1].respond_to?(:line_list)
            result += elements[1].line_list.to_sexp
          end

          result
        end

        def to_object
          to_sexp.map do |line|
            only = line[1] == :only
            CSKit::Parsers::ScienceHealth::Line.new(
              line[0].first,
              line[0].last,
              only,
              only ? nil : line[1]
            )
          end
        end
      end

      class LineNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          elements.flat_map { |e| e.to_sexp if e.respond_to?(:to_sexp) }
        end
      end

      class CompoundLineNumberNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[line_number1.text_value.to_i, line_number2.text_value.to_i]]
        end
      end

      class LineNumberNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          [[text_value.to_i, nil]]
        end
      end

      class OnlyNode < Treetop::Runtime::SyntaxNode
        def to_sexp
          :only
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