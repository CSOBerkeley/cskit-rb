require 'cskit'
require 'cskit/bible/kjv'

# puts `tt /Users/legrandfromage/workspace/cskit-rb/lib/cskit/parsers/bible/bible.treetop`

volume = CSKit.get_volume(:bible_kjv)
citation = volume.parse_citation("Neh. 6:1 (to 1st ;)")
readings = volume.readings_for(citation)
formatter = CSKit::Formatters::Bible::BiblePlainTextFormatter.new
puts formatter.format_readings(readings)
