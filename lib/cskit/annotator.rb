# encoding: UTF-8

module CSKit
  class Annotator

    attr_reader :config

    def initialize(config)
      @config = config
    end

    Annotation = Struct.new(:start, :finish, :text)

  end
end