module Csv2hash
  module Discover

    def find_position cell
      y, x = cell.rules.fetch :position
      column, matcher = y
      y = data_source.index { |entries| entries[column] =~ matcher }
      raise "Y doesn't found for #{cell.rules[:position]} on :#{cell.rules.fetch(:key)}" unless y
      cell.rules[:position] = [y, x]
    end

  end
end
