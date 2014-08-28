require_relative '../expectation'

module Csv2hash
  module Parser
    module Collection
      include Parser
      include Expectation

      def fill!
        self.data = {}.tap do |data_computed|
          data_computed[:data] ||= []
          self.data_source.each_with_index do |line, y|
            next if unexpected_line?(line, y)
            data_computed[:data] << {}.tap do |data_parsed|
              fill_it data_parsed, line
            end
          end
        end
      end

      def fill_it parsed_data, source_data
        definition.rules.each do |rule|
          if rule.fetch :mappable
            x = rule.fetch :position
            if (nested = rule.fetch :nested)
              parsed_data[nested] ||= {}
              parsed_data[nested][rule.fetch(:key)] = source_data[x]
            else
              parsed_data[rule.fetch(:key)] = source_data[x]
            end
          end
        end
      end

    end
  end
end
