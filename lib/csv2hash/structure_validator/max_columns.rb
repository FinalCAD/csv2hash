module Csv2hash
  module StructureValidator
    class MaxColumns

      include Validator

      def initialize max_size
        @max_size = max_size
      end

      def validate_line line
        line.size > @max_size
      end

      def error_message line
        "Too many columns (max. #{@max_size}) on line #{line}"
      end
    end
  end
end
