# encoding: UTF-8

module CSKit
  module Parsers
    module ScienceHealth

      Citation = Struct.new(:page, :lines)

      Line = Struct.new(:start, :finish, :only, :start_fragment) do
        alias :only? :only
      end

    end
  end
end