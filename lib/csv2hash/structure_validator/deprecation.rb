module Csv2hash
  module StructureValidator
    module Deprecation

      OLD_MAX_COLUMN = 'MaxColumns'.freeze
      OLD_MIN_COLUMN = 'MinColumns'.freeze
      OLD_RULES_NAME = [ OLD_MIN_COLUMN, OLD_MAX_COLUMN ]
      NEW_SYNTAX = { OLD_MIN_COLUMN => 'min_columns', OLD_MAX_COLUMN => 'max_columns' }

      def check_params rule
        if OLD_RULES_NAME.include? rule
          warn "[DEPRECATION]: `#{rule}` is deprecated.  Please use `#{NEW_SYNTAX[rule]}` instead."
          NEW_SYNTAX[rule]
        else
          rule.to_s
        end
      end

    end
  end
end
