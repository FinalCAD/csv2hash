module Csv2hash
  module Discover

    def find_dynamic_position cell, header = nil
      header.present? ? find_dynamic_position_x(cell, header) : find_dynamic_position_y(cell)
    end

    private 
      def find_dynamic_position_y cell
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

      def find_dynamic_position_x cell, header
        x = cell.rules.fetch :position
        dynamic_x_axe = header.index { |column| column =~ x }

        if dynamic_x_axe.nil?
          if cell.rules.fetch(:allow_blank)
            return nil
          else
            raise "Column doesn't found in #{definition.name}"
          end
        else
          cell.rules[:position] = dynamic_x_axe
          cell
        end
      end
  end
end
