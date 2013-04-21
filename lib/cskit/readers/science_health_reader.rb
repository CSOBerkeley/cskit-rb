# encoding: UTF-8

include CSKit::Books::ScienceHealth

module CSKit
  module Readers
    class ScienceHealthReader

      attr_reader :resource_path

      def initialize(resource_path)
        @resource_path = resource_path
      end

      def text_for(citation)
        "TBD"
      end

      def get_page(page_number)
        resource_file = File.join(resource_path, "#{page_number}.json")
        page_cache[page_number] = Page.from_hash(JSON.parse(File.read(resource_file)))
      end

      def get_line(line_number, page_number)
        get_page(page_number).lines[line_number - 1]
      end

      protected

      def page_cache
        @page_cache ||= {}
      end

    end
  end
end
