class Csv2hash
  module Validator

    attr_accessor :errors, :exception

    def validate_rules y=nil
      definition.rules.each do |rule|
        _y, x = position rule.fetch(:position)
        begin
          validate_cell (_y||y), x, rule
        rescue => e
          errors << { y: (_y||y), x: x, message: e.message, key: rule.fetch(:key) }
          raise if exception
        end
      end
    end

    def valid?() errors.empty?; end

    protected

    def validate_cell y, x, rule
      value = data_source[y][x] rescue nil
      begin
        raise unless value unless rule.fetch :allow_blank
        if value && (values = rule.fetch :values)
          raise unless values.include?(value)
        end
      rescue => e
        raise message(rule, y, x)
      end
    end

    def message rule, y, x
      msg = rule.fetch(:message).tap do |msg|
        rule.each { |key, value| msg.gsub!(":#{key.to_s}", value.to_s) unless key == :position }
      end
      msg.gsub ':position', "[#{y}, #{x}]"
    end

  end
end
