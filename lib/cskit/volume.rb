# encoding: UTF-8

module CSKit
  class Volume

    attr_reader :config

    def initialize(config)
      @config = config
    end

    def parse_citation(citation_text)
      config[:parser].new(citation_text).parse
    end

    def readings_for(citation)
      reader.readings_for(citation)
    end

    def reader
      @reader ||= config[:reader].new(self)
    end

    def resource_path
      config[:resource_path]
    end

  end
end
