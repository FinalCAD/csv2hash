module Csv2hash
  module Discover

    def find_dynamic_position cell
      y, x = cell.rules.fetch :position
      column, matcher = y
      dynamic_y_axe = data_source.index { |entries| entries[column] =~ matcher }

      if dynamic_y_axe.nil?
        if cell.rules.fetch(:allow_blank)
          return nil
        else
          raise "Y doesn't found for #{cell.rules[:position]} on :#{cell.rules.fetch(:key)}"
        end
      else
        cell.rules[:position] = [dynamic_y_axe, x]
        cell
      end
    end

  end
end
