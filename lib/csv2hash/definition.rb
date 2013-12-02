class Definition

  MAPPING = 'mapping'
  COLLECTION = 'collection'

  TYPES = [Definition::MAPPING, Definition::COLLECTION]

  attr_accessor :rules, :type, :header_size

  def initialize rules, type, header_size=0
    @rules, @type, @header_size = rules, type, header_size
  end

  def validate!
    unless TYPES.include?(type)
      raise "not suitable type, please use '#{Definition::MAPPING}' or '#{Definition::COLLECTION}'"
    end
    raise 'rules must be an Array of rules' unless rules.class == Array
  end

  def default!
    rules.each do |rule|
      default_position rule
      unless rule.has_key? :message
        if rule.has_key? :values
          rule.merge! message: ':key not supported, please use one of :values'
        else
          rule.merge! message: 'undefined :key on :position'
        end
      end
      rule.merge! mappable:    true                          unless rule.has_key? :mappable
      rule.merge! type:       'string'                       unless rule.has_key? :type
      rule.merge! values:      nil                           unless rule.has_key? :values
      rule.merge! nested:      nil                           unless rule.has_key? :nested
      rule.merge! allow_blank: false                         unless rule.has_key? :allow_blank
    end
  end

  private

  def default_position rule
    case type
    when Definition::MAPPING
      y, x = rule.fetch(:position, ['undefined', 'undefined'])
      rule.merge! key: "key_#{y}_#{x}" unless rule.has_key? :key
    when Definition::COLLECTION
      x = rule.fetch :position
      rule.merge! key: "key_undefined_#{x}" unless rule.has_key? :key
    end
  end

end