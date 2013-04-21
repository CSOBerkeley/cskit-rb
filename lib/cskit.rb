# encoding: UTF-8

require 'cskit/parsers'
require 'cskit/readers'
require 'cskit/book'
require 'cskit/resources/books'

require 'treetop'
require 'json'

module CSKit

  class << self
    def register_book(config)
      available_books[config[:id]] = CSKit::Book.new(config)
    end

    def get_book(book_id)
      available_books[book_id]
    end

    def get_book_for_type(type)
      available_books.find do |book|
        book.config[:type] == type
      end
    end

    def book_available?(book_id)
      available_books.include?(book_id)
    end

    def available_books
      @available_books ||= {}
    end
  end

end