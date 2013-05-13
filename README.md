## cskit-rb

CSKit is a citation parsing and retrieval toolkit for various Christian Science textual resources.  It features a pluggable architecture, meaning all the textual data is stored in separate gems.

## Available Textual Resources

1. King James Bible ([cskit-biblekjv-rb](https://github.com/camertron/cskit-biblekjv-rb))
2. Science and Health with Key to the Scriptures ([cskit-shkts-rb](https://github.com/camertron/cskit-shkts-rb))
3. Christian Science Hymnal ([cskit-hymnal-rb](https://github.com/camertron/cskit-hymnal-rb))

## Installation

`gem install cskit`, `gem install cskit-shkts`, etc

or, with bundler:

```ruby
gem 'cskit-rb', '~> 1.0.0'
gem 'cskit-shkts-rb', '~> 1.0.0'
```

## Usage

```ruby
# base CSKit library
require 'cskit'

# will make data available from cskit-shkts-rb
require 'cskit/science_health'
```

### Basics

Requiring one of the textual resource gems (eg. `require 'cskit/science_health'`) will make the resource available as a `Volume`.  `Volume`s provide access to a single textual resource and expose, among other things, a citation parser and a text reader.  Use each `Volume`'s `parse_citation` and `readings_for` methods to parse a citations and retrieve text.  You can learn more about these specific components below.

You can ask CSKit which textual resources are currently available via the `available_volumes` method:

```ruby
require 'cskit/science_health'
require 'cskit/bible/kjv'

CSKit.available_volumes                   # { :science_health => ..., :bible => ... }
CSKit.volume_available?(:science_health)  # true
CSKit.volume_available?(:blarg)           # false
```

#### Definitions

CSKit uses vocabulary that helps consistently describe the objects in the system.  Here are a few definitions that may be helpful to you as you spelunk this documentation and the source code:

1. **Volume**: A textual resource.  This should probably have been named "book", but "book of the bible" introduces ambiguity, so "volume" it is.
2. **Citation**: References text in a volume.  Parsers generate citation objects, and citation objects are passed to readers.
3. **Parser**: Converts a citation string into a citation object so it can be used to retrieve text.
4. **Reader**: An interface for retrieving text from a volume.
5. **Lesson**: A collection of citations divided into sections.  Each section contains a number of citations and their corresponding volumes.  Analogous to the weekly Christian Science Bible Lesson.
6. **Section**: A list of homogeneous citations.  All citations reference text in the same volume.
7. **Formatter**: Logic for rendering readings.
8. **Reading**: Text for a single citation.  Made up of multiple texts.
9. **Text**: A single unit of text, eg. line, verse, etc.

### Lessons

CSKit features a `Lesson` class that is capable of reading in a JSON file and assembling text from a series of volumes for a group of citations (i.e. the weekly Bible Lesson):

```ruby
include CSKit::Lesson
lesson = Lesson.from_file("/path/to/love.json")
```

You can iterate over the readings in each section using the `each_reading`, `each_formatted_reading`, and `each_formatted_section` methods.  Here are examples for each:

`each_reading` iterates over each reading in each section for the given volumes.  Formatting the text in each reading is up to you - this function returns the raw text only.

```ruby
lesson.each_reading(:bible, :science_health) do |section, citation, volume, readings|
  if volume == :bible
    readings.each do |reading|
      puts reading.texts.join(" ")
    end
  end
end
```

`each_formatted_reading` iterates over each section, handing you the formatted text for each group of readings.  More on formatters later.

```ruby
include CSKit::Formatters::ScienceHealth
include CSKit::Formatters::Bible

formatters = {
  :science_health => ScienceHealthPlainTextFormatter.new
  :bible          => BiblePlainTextFormatter.new
}

lesson.each_formatted_reading(formatters) do |section, citation, volume, text|
  if volume == :bible
    puts "Bible: #{text}"
  end
end
```

`each_formatted_section` is similar to `each_formatted_reading` but hands you a hash of formatted reading groups by volume instead of yielding each reading group one at a time.

```ruby
lesson.each_formatted_section(formatters) do |section, text_by_volume|
  puts text_by_volume[:bible]
end
```

#### File Format

Here's an example JSON file for a lesson. Note that each volume name (eg. "bible", "science_health") must match an available volume (see above).

```
[
  {
    "section": "1",
    "readings": {
      "bible": [
        "Gen. 12:1-3 the (to :)",
        "Gen. 17:1, 2, 5",
        "Gen. 22:17 in (to 1st ;), 18",
        "Ps. 91:14"
      ],
      "science_health": [
        "275:12-17",
        "579:10-14",
        "507:6-7",
        "140:8-12",
        "264:15"
      ]
    }
  },

  { ... }
]
```

### Parsing Citations

CSKit contains a number of parsers that can transform a citation string into a citation object.  For example, the `BibleParser` can read and interpret "Gen. 12:1-3 the (to :)" like so:

```ruby
include CSKit::Parsers

parser = BibleParser.new
citation = parser.parse("Gen. 12:1-3 the (to :)").to_object

citation.book                     # "Gen."
citation.chapter_list             # [#<Chapter .. >, #<Chapter .. >, ...]
citation.chapter_list.first.tap do |chapter|
  chapter.chapter_number          # 12
  chapter.verse_list              # [#<Verse ..>, ...]
  chapter.verse_list.first.tap do |verse|
    verse.start                   # 1
    verse.finish                  # 3
    verse.starter.fragment        # "and in"
    verse.terminator.fragment     # ":"
    verse.terminator.cardinality  # 1
  end
end
```

In addition, each volume provides a thin wrapper around the appropriate parser object, so you don't have to create one manually:

```ruby
volume = CSKit.get_volume(:bible)
volume.parse_citation("Gen. 12:1-3 the (to :)")  # returns a citation object
```

### Retrieving Citations

Once you have a citation object, you'll likely want to fetch text - the responsibility of a reader.  Readers take in citations and return an array of `Reading` objects:

```ruby
include CSKit::Readers

reader = BibleReader.new(volume)
reader.get_book("Genesis")         # #<Book .. >
reader.get_chapter(12, "Genesis"), # #<Chapter .. >

reader.readings_for(citation)      # [#<Reading .. >, ... ]
```

In addition, each volume provides a thin wrapper around the appropriate reader object, so you don't have to create one manually:

```ruby
volume.readings_for(citation)  # [#<Reading .. >, ... ]
```

### Formatting Text

Now that you have text in the form of `Reading` objects, you might want to format it for display - the responsibility of a formatter.  Currently, CSKit contains two formatters, one for the Bible and another for Science and Health.  Both of these format `Reading` objects as plain text.  If you'd like to apply a different style of formatting (eg. HTML), you'll need to create your own class.

Here's a formatting example for the Bible citation we've been using:

```ruby
include CSKit::Formatters::Bible

readings = reader.readings_for(citation)

# these options are actually the defaults, shown here for demonstration purposes
formatter = BiblePlainTextFormatter.new(
  :include_verse_number => true,
  :separator => " "
)

formatter.format_readings(readings)
```

The formatted output:

```
1 ...the LORD had said unto Abram, Get thee out of thy country, and from thy kindred, and from thy father's house, unto a land that I will shew thee: 2 And I will make of thee a great nation, and I will bless thee, and make thy name great; and thou shalt be a blessing: 3 And I will bless them that bless thee, and curse him that curseth thee:
```

For Science and Health, use the `ScienceHealthPlainTextFormatter` class.

## Requirements

CSKit needs to parse JSON, so it depends on the json gem.

## Running Tests

`bundle exec rake` will run the test suite, although at the current time there are no tests :(

## Authors

* Cameron C. Dutro: http://github.com/camertron

## Links
* Project Gutenberg: [http://gutenberg.org/](http://gutenberg.org/)

## License

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
