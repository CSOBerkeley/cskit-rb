require 'cskit'
require 'cskit/bible/kjv'
require 'pry'

# puts `tt /Users/legrandfromage/workspace/cskit-rb/lib/cskit/parsers/bible/bible.treetop`

book = CSKit.get_book(:bible_kjv)
# citation = book.parse_citation("Psalms 86:3-5, 13, 15 thou")
citation = book.parse_citation("Proverbs 16:11 (to :)")
puts book.text_for(citation)