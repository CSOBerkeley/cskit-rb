# encoding: UTF-8

module CSKit
  module Registry
    def family(family, plural_family)
      extend RegistryFactory.create(family, plural_family)
    end

    def registry
      @registry ||= {}
    end
  end

  class RegistryFactory
    class << self

      def create(family, plural_family)
        Module.new do
          define_method :"register_#{family}" do |config|
            register(family, config[:id], config[family].new(config))
          end

          define_method :"get_#{family}" do |id|
            get(family, id)
          end

          define_method :"#{plural_family}" do
            all(family)
          end

          define_method :"#{family}_available?" do |id|
            available?(family, id)
          end

          private

          def register(family, key, obj)
            (registry[family.to_sym] ||= {})[key.to_sym] = obj
          end

          def get(family, key)
            registry[family.to_sym][key.to_sym] || get_for_family(family, key)
          end

          def all(family)
            registry.fetch(family, [])
          end

          def get_for_family(family, type)
            found = registry[family.to_sym].find do |key, obj|
              obj.config[:type] == type
            end

            found.last if found
          end

          def available?(family, key)
            !!registry[family.to_sym][key.to_sym] rescue false
          end
        end
      end

    end
  end
end
