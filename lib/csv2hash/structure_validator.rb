# require 'active_support/core_ext'

module Csv2hash::StructureValidator
  class ValidationError < StandardError ; end

  def validate_structure!
    definition.structure_rules.each do |rule, options|
      begin
        rule_instance(rule, options).validate! data_source
      rescue => e
        self.errors << { y: nil, x: nil, message: e.message, key: nil }
        raise if exception_mode
      end
    end
  end

  def rule_instance rule, options
    Csv2hash::StructureValidator.const_get(rule).new(options)
    # 'min_columns'.camelize.constantize.new
  end

  module Validator
    def validate! source
      source.index { |line| validate_line line }.tap do |line|
        raise Csv2hash::StructureValidator::ValidationError, error_message(line) unless line.nil?
      end
      true
    end
  end
end
