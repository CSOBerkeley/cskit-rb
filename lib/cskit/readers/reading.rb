# encoding: UTF-8

module CSKit
  module Readers

    Reading = Struct.new(:texts, :citation) do
      def params
        @params || {}
      end
    end

  end
end