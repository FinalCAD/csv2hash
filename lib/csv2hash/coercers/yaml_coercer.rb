module Csv2hash
  module Coercers
    class YamlCoercer < Struct.new(:rules)

      def deserialize!
        deserialize_validator!
        deserialize_regex!
        deserialize_range!
      end

      private

      def deserialize_validator!
        begin
          extra_validator = self.rules.fetch(:extra_validator)
          self.rules[:extra_validator] = eval("::#{extra_validator}").new
        rescue KeyError # Rules without ExtraValidator
        rescue SyntaxError # When extra validator is a instance of Object
        end
      end

      def deserialize_regex!
        y, x = self.rules.fetch :position
        if y.is_a?(Array)
          column, matcher_string = y
          self.rules[:position] = [[column, Regexp.new(matcher_string)],x]
        end
      end

      def deserialize_range!
        begin
          values = self.rules.fetch(:values)
          if values.is_a?(String)
            match_data = values.match(/^\((?<range>.*)\)$/)
            self.rules[:values] = eval(match_data[:range])
          end
        rescue KeyError # Rules without ExtraValidator
        end
      end

    end
  end
end
