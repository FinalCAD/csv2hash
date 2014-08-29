require 'active_support/core_ext'

require_relative 'structure_validator/deprecation'

module Csv2hash
  module StructureValidator
    include Deprecation

    class ValidationError < StandardError ; end

    MAX_COLUMN = 'max_columns'.freeze
    MIN_COLUMN = 'min_columns'.freeze
    RULES_NAME = [ MIN_COLUMN, MAX_COLUMN ]

    def validate_structure!
      definition.structure_rules.each do |rule, options|
        begin
          rule_instance(rule, options).validate! data_source
        rescue => e
          self.errors << { y: nil, x: nil, message: e.message, key: nil }
          raise if break_on_failure
        end
      end
    end

    def rule_instance rule, options
      _rule = check_params rule
      begin
        StructureValidator.const_get(_rule.camelize).new(options)
      rescue NameError => e
        raise "Structure rule #{rule} unknow, please use one of these #{RULES_NAME}"
      end
    end

    module Validator
      def validate! source
        source.index { |line| validate_line line }.tap do |line|
          raise ValidationError, error_message(line) unless line.nil?
        end
        true
      end
    end

  end
end
