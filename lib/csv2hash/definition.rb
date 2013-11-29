class Csv2Hash
  class Definition

    MAPPING = 'mapping'
    COLLECTION = 'collection'

    TYPES = [MAPPING, COLLECTION]

    attr_accessor :rules, :type, :header_size

    def initialize rules, type, header_size=0
      @rules, @type, @header_size = rules, type, header_size
    end

    def validate!
      unless TYPES.include?(type)
        raise "not suitable type, please use '#{MAPPING}' or '#{COLLECTION}'"
      end
      raise 'rules must be an Array of rules' unless rules.class == Array
    end

    def default!
      rules.each do |rule|
        default_position rule
        rule.merge! message:     'undefined :key on :position' unless rule.has_key? :message
        rule.merge! type:        'string'                      unless rule.has_key? :type
        rule.merge! values:      nil                           unless rule.has_key? :values
        rule.merge! nested:      nil                           unless rule.has_key? :nested
        rule.merge! allow_blank: false                         unless rule.has_key? :allow_blank
      end
    end

    private

    def default_position rule
      case type
      when MAPPING
        x, y = rule.fetch(:position, ['undefined', 'undefined'])
        rule.merge! key: "key_#{x}_#{y}" unless rule.has_key? :key
      when COLLECTION
        y = rule.fetch :position
        rule.merge! key: "key_#{y}" unless rule.has_key? :key
      end
    end

  end
end
