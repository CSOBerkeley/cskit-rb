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

  class << self
    def register_volume(config)
      available_volumes[config[:id].to_sym] = config[:volume].new(config)
    end

    def get_volume(volume_id)
      volume_id = volume_id.to_sym
      available_volumes[volume_id] || get_volume_for_type(volume_id)
    end

    def get_volume_for_type(type)
      found_volume = available_volumes.find do |volume_id, volume|
        volume.config[:type] == type
      end

      found_volume.last if found_volume
    end

    def volume_available?(volume_id)
      available_volumes.include?(volume_id)
    end

    def available_volumes
      @available_volumes ||= {}
    end
  end

end