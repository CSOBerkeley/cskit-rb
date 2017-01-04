# encoding: UTF-8

module CSKit
  module Formatters
    module Bible
      autoload :BibleHtmlFormatter,      'cskit/formatters/bible/bible_html_formatter'
      autoload :BibleJsonFormatter,      'cskit/formatters/bible/bible_json_formatter'
      autoload :BiblePlainTextFormatter, 'cskit/formatters/bible/bible_plain_text_formatter'
    end
  end
end
