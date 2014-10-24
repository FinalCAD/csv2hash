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
        definition.cells.each do |cell|
          if cell.rules.fetch :mappable
            x = cell.rules.fetch :position
            if (nested = cell.rules.fetch :nested)
              parsed_data[nested] ||= {}
              parsed_data[nested][cell.rules.fetch(:key)] = treat(source_data[x])
            else
              parsed_data[cell.rules.fetch(:key)] = treat(source_data[x])
            end
          end
        end
      end

    end
  end
end
