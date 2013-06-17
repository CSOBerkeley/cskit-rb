# encoding: UTF-8

module CSKit
  module Parsers
    module ScienceHealth

      module ToJson
        def to_json
          to_hash.to_json
        end
      end
      

      Citation = Struct.new(:page, :lines) do
        include ToJson

        def to_s
          "#{page}:#{lines.map(&:to_s).join(", ")}"
        end

        def to_hash
          {
            :page => page,
            :lines => lines.map(&:to_hash)
          }
        end
      end

      Line = Struct.new(:start, :finish, :only, :start_fragment) do
        include ToJson

        alias :only? :only

        def to_s
          str = if finish
            "#{start}-#{finish}"
          else
            start.to_s
          end

          str << " (only)" if only?
          str << " #{start_fragment}" if start_fragment
          str
        end

        def to_hash
          {
            :start => start,
            :finish => finish,
            :only => only,
            :start_fragment => start_fragment
          }
        end
      end

    end
  end
end