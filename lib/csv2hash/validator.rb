module Validator

  attr_accessor :errors, :exception

  def validate_rules y=nil
    definition.rules.each do |rule|
      x, _y = position rule.fetch(:position)
      begin
        validate_cell x, (_y||y), rule
      rescue => e
        errors << { x: x, y: (_y||y), message: e.message }
        raise if exception
      end
    end
  end

  def valid?() errors.empty?; end

  protected

  def validate_cell x, y, rule
    begin
      unless rule.fetch :allow_blank
        raise unless data_source[y][x]
      end
      if (values = rule.fetch :values)
        raise unless values.include?(data_source[y][x])
      end
    rescue => e
      raise message(rule, x, y)
    end
  end

  def message rule, x, y
    msg = rule.fetch(:message).tap do |msg|
      rule.each { |key, value| msg.gsub!(":#{key.to_s}", value.to_s) unless key == :position }
    end
    msg.gsub ':position', "[#{x}, #{y}]"
  end

end