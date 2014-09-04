module Csv2hash
  class Coercer < Struct.new(:rules)

    def from_yml!
      deserialize_validator!
      deserialize_regex!
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

  end
end
