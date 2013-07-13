# encoding: UTF-8

include CSKit::Volumes

module CSKit
  module Readers
    class BibleReader

      attr_reader :volume

      def initialize(volume)
        @volume = volume
      end

      def get_book(book_name)
        converted_book_name = convert_book_name(book_name)
        volume.get_book(converted_book_name)
      end

      def get_chapter(chapter_number, book_name)
        converted_book_name = convert_book_name(book_name)
        volume.get_chapter(chapter_number, converted_book_name)
      end

      def get_line(line_number, page_number)
        get_page(page_number).lines[line_number - 1]
      end

      def readings_for(citation)
        citation.chapter_list.flat_map do |chapter|
          map_verse_texts_for(chapter, citation.book) do |texts, verse|
            Reading.new(texts, citation, chapter, verse)
          end
        end
      end

      protected

      def map_verse_texts_for(chapter, book_name)
        result = []
        chapter_data = get_chapter(chapter.chapter_number, book_name)
        chapter.verse_list.each do |verse|
          texts = []
          verse.start.upto(verse.finish) do |i|
            texts << chapter_data.verses[i - 1].text
          end
          result << (yield texts, verse)
        end
        result
      end

      def convert_book_name(book_name)
        volume.unabbreviate_book_name(book_name).downcase.gsub(" ", "_")
      end

    end
  end
end
