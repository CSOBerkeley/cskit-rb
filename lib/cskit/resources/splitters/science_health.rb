# encoding: UTF-8

module CSKit
  module Splitters
    class ScienceHealth

      class << self
        def split(input_file, output_path)
          cur_page = []
          cur_page_number = nil

          File.open(input_file).each_line do |line|
            unless line.empty?
              
            end
          end
        end

        private

        def page_from_line(line)
          location = line[0..8].strip
        end
      end

    end
  end
end