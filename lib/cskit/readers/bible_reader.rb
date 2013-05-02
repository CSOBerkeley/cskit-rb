# encoding: UTF-8

include CSKit::Books

module CSKit
  module Readers
    class BibleReader

      attr_reader :resource_path

      def initialize(resource_path)
        @resource_path = resource_path
      end

      def text_for(citation)
        "TBD"
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

      protected

      def convert_book_name(book_name)
        book_name.downcase.gsub(" ", "_")
      end

      def chapter_cache
        @chapter_cache ||= {}
      end

    end
  end
end
