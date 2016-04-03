# encoding: UTF-8

module CSKit
  module Volumes
    module ScienceHealth

      Page = Struct.new(:number, :lines) do
        def preface?
          !!(number =~ /vi{2,3}|xi{1,2}|i{0,1}x/)
        end

        def to_hash
          { "number" => number, "lines" => lines.map(&:to_hash) }
        end

        def self.from_hash(hash)
          Page.new(
            hash["number"],
            hash["lines"].map { |line_hash| Line.from_hash(line_hash) }
          )
        end
      end

      Line = Struct.new(:text, :flyout_text, :paragraph_start) do
        def has_flyout?
          !!flyout_text
        end

        alias :paragraph_start? :paragraph_start

        def to_hash
          { "text" => text,
            "flyout_text" => flyout_text,
            "paragraph_start" => paragraph_start
          }
        end

        def self.from_hash(hash)
          Line.new(
            hash["text"],
            hash["flyout_text"],
            !!hash["paragraph_start"]
          )
        end
      end

    end
  end
end
