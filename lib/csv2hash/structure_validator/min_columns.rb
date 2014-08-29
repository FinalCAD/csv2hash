module Csv2hash
  module StructureValidator
    class MinColumns

      include Validator

      def initialize min_size
        @min_size = min_size
      end

      def validate_line line
        line.size < @min_size
      end

      def error_message line
        "Not enough columns (min. #{@min_size}) on line #{line}"
      end
    end
  end
end
