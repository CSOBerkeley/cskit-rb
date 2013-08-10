require 'cskit'
require 'cskit/bible/kjv'  # requires cskit-biblekjv-rb (add to Gemfile under 'development')

# Re-generate the bible parser from the treetop grammar
# puts `tt /Users/legrandfromage/workspace/cskit-rb/lib/cskit/parsers/bible/bible.treetop`

volume = CSKit.get_volume(:bible_kjv)
citation = volume.parse_citation("Neh. 6:1 (to 1st ;)")
readings = volume.readings_for(citation)
formatter = CSKit::Formatters::Bible::BibleHtmlFormatter.new
puts formatter.format_readings(readings)
