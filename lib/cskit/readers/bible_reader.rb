# encoding: UTF-8

include CSKit::Books

module CSKit
  module Readers
    class BibleReader

      attr_reader :resource_path

      def initialize(resource_path)
        @resource_path = resource_path
      end

      def get_book(book_name)
        converted_book_name = convert_book_name(book_name)
        book_resource_path = File.join(resource_path, converted_book_name)

        if File.directory?(book_resource_path)
          Bible::Book.new(book_name, Dir.glob(File.join(book_resource_path, "**")).map.with_index do |resource_file, index|
            get_chapter(index + 1, book_name)
          end)
        else
          nil
        end
      end

      def get_chapter(chapter_number, book_name)
        book_name = convert_book_name(book_name)
        book_resource_path = File.join(resource_path, book_name)
        resource_file = File.join(book_resource_path, "#{chapter_number}.json")
        chapter_cache[resource_file] ||= Bible::Chapter.from_hash(JSON.parse(File.read(resource_file)))
      end

      def get_line(line_number, page_number)
        get_page(page_number).lines[line_number - 1]
      end

      def text_for(citation)
        chapter = get_chapter(citation.chapter, citation.book)
        text_for_chapter(chapter, citation).join(" ")
      end

      protected

      # @TODO: extract formatting functionality into a Formatter class.
      # Formatting should not be the Reader's responsibility
      def text_for_chapter(chapter, citation)
        citation.verse_list.inject([]) do |text, citation_verse|
          citation_verse.start.upto(citation_verse.finish) do |i|
            verse_text = chapter.verses[i - 1].text

            if citation_verse.start_fragment
              verse_text = verse_text[verse_text.index(citation_verse.start_fragment)..-1]
            end

            if citation_verse.terminator
              stop_pos = (0...citation_verse.terminator.cardinality).inject(-1) do |last_index, _|
                verse_text.index(citation_verse.terminator.fragment, last_index + 1)
              end

              verse_text = verse_text[0..stop_pos]
            end

            text << "#{i} #{verse_text}"
          end

          text
        end
      end

      def convert_book_name(book_name)
        book_name.downcase.gsub(" ", "_")
      end

      def chapter_cache
        @chapter_cache ||= {}
      end

    end
  end
end
