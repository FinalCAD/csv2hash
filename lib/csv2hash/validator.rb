require_relative 'discover'

module Csv2hash
  module Validator
    include Discover

    def validate_rules y=nil
      find_or_remove_dynamic_fields! if definition.type == Definition::MAPPING

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
        if (extra_validator = cell.rules.fetch :extra_validator) && extra_validator.kind_of?(ExtraValidator)
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
        raise message(cell, y, x, value)
      end
    end

    def message cell, y, x, value
      msg = cell.rules.fetch(:message)
      msg = msg.gsub(':position', "[#{y}, #{x}]")
      msg = msg.gsub(':key', ":#{cell.rules.fetch(:key, :no_key_given)}")
      msg = msg.gsub(':found', "<#{value}>")
      msg = msg.gsub(':values', "<#{cell.rules.fetch(:values, :no_values_given)}>")
      cell.rules.each { |key, _value| msg.gsub!(":#{key.to_s}", _value.to_s) unless key == :position }
      msg
    end

    private

    def find_or_remove_dynamic_fields!
      cells = definition.cells.dup
      _cells = []

      while(!cells.empty?) do
        cell = cells.pop
        _y, x = cell.rules.fetch(:position)
        if dynamic_field?(_y)
          begin
            _cell = find_dynamic_position cell
            _cells << _cell if _cell
          rescue => e
            self.errors << { y: (_y||y), x: x, message: e.message, key: cell.rules.fetch(:key) }
            raise if break_on_failure
          end
        else
          _cells << cell
        end
      end

      definition.cells = _cells # cells without optional and not found dynamic field
      nil
    end

    def dynamic_field? field
      field.is_a?(Array)
    end

  end
end
