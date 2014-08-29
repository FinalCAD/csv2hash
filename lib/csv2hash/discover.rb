module Csv2hash
  module Discover

    def find_positions!
      definition.cells.each do |cell|
        y, x = cell.rules.fetch :position
        if y.is_a?(Array)
          column, matcher = y
          y = data_source.index { |entries| entries[column] =~ matcher }
          cell.rules[:position] = [y, x]
        end
      end
    end

  end
end
