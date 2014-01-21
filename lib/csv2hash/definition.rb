class Csv2hash
  class Definition

    MAPPING = 'mapping'
    COLLECTION = 'collection'

    TYPES = [MAPPING, COLLECTION]

    attr_accessor :rules, :type, :header_size, :structure_rules

    def initialize rules, type, options = {}
      self.rules, self.type = rules, type
      self.header_size, self.structure_rules = options.fetch(:header_size) { 0 }, options.fetch(:structure_rules) { {} }
    end

    def validate!
      unless TYPES.include?(type)
        raise "not suitable type, please use '#{MAPPING}' or '#{COLLECTION}'"
      end
      raise 'rules must be an Array of rules' unless rules.class == Array
      raise 'structure rules must be a Hash of rules' unless structure_rules.class == Hash
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
        rule.merge! mappable:    true    unless rule.has_key? :mappable
        rule.merge! type:       'string' unless rule.has_key? :type
        rule.merge! values:      nil     unless rule.has_key? :values
        rule.merge! nested:      nil     unless rule.has_key? :nested
        rule.merge! allow_blank: false   unless rule.has_key? :allow_blank
        rule.merge! extra_validator: nil unless rule.has_key? :extra_validator
      end
    end

    private

    def default_position rule
      case type
      when MAPPING
        y, x = rule.fetch(:position, ['undefined', 'undefined'])
        rule.merge! key: "key_#{y}_#{x}" unless rule.has_key? :key
      when COLLECTION
        x = rule.fetch :position
        rule.merge! key: "key_undefined_#{x}" unless rule.has_key? :key
      end
    end

  end
end
