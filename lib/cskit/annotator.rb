# encoding: UTF-8

module CSKit
  class Annotator
    attr_reader :config

    def initialize(config)
      @config = config
    end
  end

  Annotation = Struct.new(:start, :finish, :data)

end
