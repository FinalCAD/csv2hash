require 'csv2hash/version'
require 'csv2hash/definition'
require 'csv2hash/definition/mapping'

class Csv2hash

  attr_accessor :definition, :data_source

  def initialize definition, data_source
    @definition, @data_source = definition, data_source
  end

  def validate_data!
    definition.rules.each do |rule|
      if (rule.fetch(:maptype) == 'cell')
        x, y = rule.fetch :position
        validate_rule x, y, rule
      end
    end
  end

  private

  def validate_rule x, y, rule
    begin
      raise unless data_source[x]
      unless rule.fetch :allow_blank
        raise unless data_source[x][y]
      end
      if (values = rule.fetch :values)
        raise unless values.include?(data_source[x][y])
      end
    rescue => e
      raise message(rule)
    end
  end

  def message rule
    rule.fetch(:message).tap do |msg|
      rule.each { |key, value| msg.gsub! key.to_s, value.to_s }
    end
  end

end