require 'cskit'
require 'cskit/science_health'

# puts `tt /Users/legrandfromage/workspace/cskit-rb/lib/cskit/parsers/bible/bible.treetop`

volume = CSKit.get_volume(:science_health)
citation = volume.parse_citation("192:30-2")
readings = volume.readings_for(citation)
formatter = CSKit::Formatters::ScienceHealth::ScienceHealthPlainTextFormatter.new
puts formatter.format_readings(readings)
