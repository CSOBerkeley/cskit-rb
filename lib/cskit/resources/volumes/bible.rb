# encoding: UTF-8

module CSKit
  module Volumes
    module Bible

      Book = Struct.new(:name, :chapters) do
        def to_hash
          { "name" => name, "chapters" => chapters.map(&:to_hash) }
        end

        def self.from_hash(hash)
          Book.new(
            hash["name"],
            hash["chapters"].map { |chapter_hash| Chapter.from_hash(chapter_hash) }
          )
        end
      end

      Chapter = Struct.new(:number, :verses) do
        def to_hash
          { "number" => number, "verses" => verses.map(&:to_hash) }
        end

        def self.from_hash(hash)
          Chapter.new(
            hash["number"],
            hash["verses"].map { |verse_hash| Verse.from_hash(verse_hash) }
          )
        end
      end

      Verse = Struct.new(:text) do
        def to_hash
          { "text" => text }
        end

        def self.from_hash(hash)
          Verse.new(hash["text"])
        end
      end

    end
  end
end