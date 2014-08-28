module Csv2hash
  module Validator

    def validate_rules y=nil
      definition.rules.each do |rule|
        _y, x = position rule.fetch(:position)
        begin
          validate_cell (_y||y), x, rule
        rescue => e
          self.errors << { y: (_y||y), x: x, message: e.message, key: rule.fetch(:key) }
          raise if break_on_failure
        end
      end
    end

    def valid?() self.errors.empty?; end

    protected

    def validate_cell y, x, rule
      value = data_source[y][x] rescue nil
      begin
        raise unless value unless rule.fetch :allow_blank
        if (extra_validator = rule.fetch :extra_validator) && extra_validator.kind_of?(Csv2hash::ExtraValidator)
          raise unless extra_validator.valid? rule, value
        else
          if value && (values = rule.fetch :values)
            if values.class == Range
              raise unless values.include?(value.to_f)
            else
              raise unless values.include?(value)
            end
          end
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
