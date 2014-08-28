module Csv2hash
  module Validator

    def validate_rules y=nil
      # binding.pry
      definition.cells.each do |cell|
        _y, x = position cell.rules.fetch(:position)
        begin
          validate_cell (_y||y), x, cell
        rescue => e
          self.errors << { y: (_y||y), x: x, message: e.message, key: cell.rules.fetch(:key) }
          raise if break_on_failure
        end
      end
    end

    def valid?() self.errors.empty?; end

    protected

    def validate_cell y, x, cell
      value = data_source[y][x] rescue nil
      begin
        raise unless value unless cell.rules.fetch :allow_blank
        if (extra_validator = cell.rules.fetch :extra_validator) && extra_validator.kind_of?(Csv2hash::ExtraValidator)
          raise unless extra_validator.valid? cell.rules, value
        else
          if value && (values = cell.rules.fetch :values)
            if values.class == Range
              raise unless values.include?(value.to_f)
            else
              raise unless values.include?(value)
            end
          end
        end
      rescue => e
        raise message(cell, y, x)
      end
    end

    def message cell, y, x
      msg = cell.rules.fetch(:message).tap do |msg|
        cell.rules.each { |key, value| msg.gsub!(":#{key.to_s}", value.to_s) unless key == :position }
      end
      msg.gsub ':position', "[#{y}, #{x}]"
    end

  end
end
