# encoding: UTF-8

module CSKit
  module Readers

    Reading = Struct.new(:text, :citation, :params) do
      def params
        @params || {}
      end
    end

  end
end