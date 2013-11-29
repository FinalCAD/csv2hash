module Validator

  def validate_line line, y=nil
    definition.rules.each do |rule|
      x, _y = position rule.fetch(:position)
      validate_rule line, x, (_y||y), rule
    end
  end

  protected

  def validate_rule _data, x, y, rule
    begin
      raise unless _data[x]
      unless rule.fetch :allow_blank
        raise unless _data[x][y]
      end
      if (values = rule.fetch :values)
        raise unless values.include?(_data[x][y])
      end
    rescue => e
      raise message(rule, x, y)
    end
  end

  def message rule, x, y
    msg = rule.fetch(:message).tap do |msg|
      rule.delete :position
      rule.each { |key, value| msg.gsub! ":#{key.to_s}", value.to_s }
    end
    msg.gsub ':position', "[#{x}, #{y}]"
  end

end