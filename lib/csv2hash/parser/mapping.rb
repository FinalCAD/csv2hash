module Csv2hash
  module Parser
    module Mapping
      include Parser

      def fill!
        self.data = {}.tap do |data_computed|
          data_computed[:data] ||= []
          data_computed[:data] << {}.tap do |data_parsed|
            fill_it data_parsed, data_source
          end
        end
      end

      def fill_it parsed_data, source_data
        definition.cells.each do |cell|
          if cell.rules.fetch :mappable
            y, x = cell.rules.fetch :position
            if (nested = cell.rules.fetch :nested)
              parsed_data[nested] ||= {}
              parsed_data[nested][cell.rules.fetch(:key)] = treat(source_data[y][x])
            else
              parsed_data[cell.rules.fetch(:key)] = treat(source_data[y][x])
            end
          end
        end
      end

    end
  end
end
