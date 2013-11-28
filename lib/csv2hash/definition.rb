class Definition

  MAPPING = 'mapping'
  COLLECTION = 'collection'

  TYPES = [Definition::MAPPING, Definition::COLLECTION]

  attr_accessor :type, :rules

  def validate!
    unless TYPES.include?(type)
      raise "not suitable type, please use '#{Definition::MAPPING}' or '#{Definition::COLLECTION}'"
    end
    raise 'rules must be an Array of rules' unless rules.class == Array
  end

  def default!
    rules.each do |rule|
      default_position rule
      rule.merge! message:     'undefined :key on :position' unless rule.has_key? :message
      rule.merge! mappable:    true                          unless rule.has_key? :mappable
      rule.merge! type:       'string'                       unless rule.has_key? :type
      rule.merge! values:      nil                           unless rule.has_key? :values
      rule.merge! nested:      nil                           unless rule.has_key? :nested
      rule.merge! allow_blank: false                         unless rule.has_key? :allow_blank
      rule.merge! position:    nil                           unless rule.has_key? :position
      rule.merge! maptype:     'cell'                        unless rule.has_key? :maptype
    end
  end

  private

  def default_position rule
    case type
    when Definition::MAPPING
      x, y = rule.fetch(:position, ['undefined', 'undefined'])
      rule.merge! key: "key_#{x}_#{y}" unless rule.has_key? :key
    when Definition::COLLECTION
      y = rule.fetch :position
      rule.merge! key: "key_#{y}" unless rule.has_key? :key
    end
  end

end