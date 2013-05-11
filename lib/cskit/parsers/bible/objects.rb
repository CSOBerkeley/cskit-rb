# encoding: UTF-8

module CSKit
  module Parsers
    module Bible

      Citation = Struct.new(:book, :chapter_list)
      Chapter = Struct.new(:chapter_number, :verse_list)
      Verse = Struct.new(:start, :finish, :start_fragment, :terminator)
      Terminator = Struct.new(:cardinality, :fragment)

    end
  end
end