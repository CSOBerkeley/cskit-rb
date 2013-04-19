module CSKit
  module Parsers
    module Bible

      Citation = Struct.new(:book, :chapter, :verse_list)
      Verse = Struct.new(:start, :finish, :fragment, :terminator)
      Terminator = Struct.new(:cardinality, :fragment)

    end
  end
end