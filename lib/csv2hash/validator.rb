require_relative 'discover'

module Csv2hash
  module Validator
    include Discover

    def validate_rules y=nil
      definition.type == Definition::MAPPING ? find_or_remove_dynamic_fields_on_mapping! : find_or_remove_dynamic_fields_on_collection!(y)
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
        verify_blank! cell, value
        if extra_validator?(cell)
          verify_extra_validator! cell, value
        else
          if rang? cell, value
            values = cell.rules.fetch(:values)
            verify_rang! values, value
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

    def extra_validator? cell
      (extra_validator = cell.rules.fetch(:extra_validator)) && extra_validator.kind_of?(ExtraValidator)
    end

    def verify_extra_validator! cell, value
      raise unless cell.rules.fetch(:extra_validator).valid? cell.rules, value
    end

    def verify_blank! cell, value
      raise unless value unless cell.rules.fetch :allow_blank
    end

    def rang? cell, value
      value && (values = cell.rules.fetch(:values))
    end

    def verify_rang! values, value
      if values.class == Range
        raise unless values.include?(value.to_f)
      else
        raise unless values.include?(value)
      end
    end

    def find_or_remove_dynamic_fields_on_mapping!
      cells = definition.cells.dup
      # cells without optional and not found dynamic field
      definition.cells = [].tap do |_cells|
        while(!cells.empty?) do
          cell = cells.pop
          _y, x = cell.rules.fetch(:position)
          if dynamic_field_for_mapping?(_y)
            begin
              _cell = find_dynamic_position cell
              _cells << _cell
            rescue => e
              self.errors << { y: (_y||y), x: x, message: e.message, key: cell.rules.fetch(:key) }
              raise if break_on_failure
            end
          else
            _cells << cell
          end
        end
      end.compact
      nil
    end

    def find_or_remove_dynamic_fields_on_collection! y
      cells = definition.cells.dup
      # cells without optional and not found dynamic field
      definition.cells = [].tap do |_cells|
        while(!cells.empty?) do
          cell = cells.pop
          x = cell.rules.fetch(:position)
          if dynamic_field_for_collection?(x)
            begin
              _cell = find_dynamic_position cell, data_source.first
              _cells << _cell
            rescue => e
              self.errors << { y: y, x: x, message: e.message, key: cell.rules.fetch(:key) }
              raise if break_on_failure
            end
          else
            _cells << cell
          end
        end
      end.compact
      nil
    end

    def dynamic_field_for_mapping? field
      field.is_a?(Array)
    end

    def dynamic_field_for_collection? field
      field.is_a?(Regexp)
    end
  end
end
