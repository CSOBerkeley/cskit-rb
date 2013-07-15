# encoding: UTF-8

require 'cskit/formatters'
require 'cskit/lesson'
require 'cskit/parsers'
require 'cskit/readers'
require 'cskit/volume'
require 'cskit/resources/volumes'

require 'treetop'
require 'json'

module CSKit

  autoload :Annotator,       "cskit/annotator"
  autoload :Annotation,      "cskit/annotator"
  autoload :AnnotatedString, "cskit/annotated_string"

  class << self

    def register_volume(config)
      register(:volume, config[:id], config[:volume].new(config))
    end

    def register_annotator(config)
      register(:annotator, config[:id], config[:annotator].new(config))
    end

    def get_volume(volume_id)
      get(:volume, volume_id)
    end

    def get_annotator(annotator_id)
      get(:annotator, annotator_id)
    end

    def volume_available?(volume_id)
      available?(:volume, volume_id)
    end

    def annotator_available?(annotator_id)
      available?(:annotator, annotator_id)
    end

    private

    def register(family, key, obj)
      (registry[family.to_sym] ||= {})[key.to_sym] = obj
    end

    def get(family, key)
      registry[family.to_sym][key.to_sym] || get_for_type(family, key)
    end

    def get_for_type(family, type)
      found = registry[family.to_sym].find do |key, obj|
        obj.config[:type] == type
      end

      found.last if found
    end

    def available?(family, key)
      !!registry[family.to_sym][key.to_sym] rescue false
    end

    def registry
      @registry ||= {}
    end

  end

end