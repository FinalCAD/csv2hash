require_relative '../expectation'

module Csv2hash
  module Validator
    module Collection
      include Validator
      include Expectation

      def validate_data!
        self.data_source.each_with_index do |line, y|
          next if unexpected_line?(line, y)
          validate_rules y
        end
        nil
      end

      protected

      def position _position
        [nil, _position]
      end

    end
  end
end
