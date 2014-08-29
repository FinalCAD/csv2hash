module Csv2hash
  class Definition

    MAPPING = 'mapping'.freeze
    COLLECTION = 'collection'.freeze

    TYPES = [ MAPPING, COLLECTION ]

    attr_accessor :cells, :structure_rules, :header_size
    attr_reader :type, :name

    def initialize name, &blk
      @name = name
      self.cells = []
      self.header_size = 0
      self.structure_rules = {}
      instance_eval(&blk) if block_given?
    end

    def mapping &blk
      instance_eval(&blk) if block_given?
    end

    def cell *args
      self.cells << Cell.new(*args)
    end

    def set_header_size &blk
      self.header_size = yield if block_given?
    end

    def set_type &blk
      @type = yield if block_given?
    end

    def set_structure_rules &blk
      self.structure_rules = yield if block_given?
    end

    def validate!
      unless TYPES.include?(@type)
        raise "not suitable type, please use '#{MAPPING}' or '#{COLLECTION}'"
      end
      raise 'cells must be an Array of cell' unless self.cells.class == Array
      raise 'structure rules must be a Hash of rules' unless self.structure_rules.class == Hash
    end

    def default!
      cells.each do |cell|
        cell.rules.fetch(:position)

        default_position cell
        unless cell.rules.has_key? :message
          if cell.rules.has_key? :values
            cell.rules.merge! message: ':key not supported, please use one of :values'
          else
            cell.rules.merge! message: 'undefined :key on :position'
          end
        end
        cell.rules.merge! mappable:    true    unless cell.rules.has_key? :mappable
        cell.rules.merge! type:       'string' unless cell.rules.has_key? :type
        cell.rules.merge! values:      nil     unless cell.rules.has_key? :values
        cell.rules.merge! nested:      nil     unless cell.rules.has_key? :nested
        cell.rules.merge! allow_blank: false   unless cell.rules.has_key? :allow_blank
        cell.rules.merge! extra_validator: nil unless cell.rules.has_key? :extra_validator
      end
    end

    private

    def default_position cell
      case type
      when MAPPING
        y, x = cell.rules.fetch(:position, ['undefined', 'undefined'])
        cell.rules.merge! key: "key_#{y}_#{x}" unless cell.rules.has_key? :key
      when COLLECTION
        x = cell.rules.fetch :position
        cell.rules.merge! key: "key_undefined_#{x}" unless cell.rules.has_key? :key
      end
    end

  end
end
