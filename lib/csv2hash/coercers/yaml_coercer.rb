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

      # Public: Extract String to Regex
      #
      # 'Sex' => /Sex/
      #
      # Returns Regex (See private method YamlCoercer#regexp)
      def deserialize_regex!
        y, x = self.rules.fetch :position
        # Value possible:
        # * (regular) [0, 0]
        # * (collection) 'Sex'
        # * (mapping) [[0, 'Sex'], 0]

        return if y.is_a?(Fixnum) # There are nothing to deserialized [0, 0]

        # Deserialize only type of (Collection) ['Sex', 0] or (Mapping) [[0, 'Sex'], 0]
        column, matching_string_expression = extract_column y

        self.rules[:position] = if y.is_a?(Array)
          [[column, regexp(matching_string_expression)],x] # (Mapping)
        else # String or Regexp
          regexp(matching_string_expression) # (Collection)
        end
      end

      # Public: Extract if is necessary the column number.
      # You have two type of position based on regex :
      # * mapping: This need a column position for searching on this column the row position (search y position)
      # * collection: Search in all columns for find column position (search x position)
      #
      # value - Array or String - example : [1,'Sex'] or 'Sex'
      #
      # Examples
      #
      #   extract_column([1, 'Sex'])
      #   # => [1, 'Sex']
      #
      #   extract_column('Sex')
      #   # => [nil, 'Sex']
      #
      # Returns a array with column position (type mapping) and matching string
      def extract_column value
        return value if value.is_a?(Array)
        [nil, value]
      end

      # Public: Return regexp from string
      #
      # term - Matching String - Example : 'Sex'
      #
      # Examples
      #
      #   regexp('Sex')
      #   # => /\A(Sex)\z/  # exact_matching: true,  ignore_case: false
      #   # => /\A(Sex)\z/i # exact_matching: true,  ignore_case: true
      #   # => /Sex/        # exact_matching: false, ignore_case: false
      #   # => /Sex/i       # exact_matching: false, ignore_case: true
      #
      # Returns a regex depend of configuration, see
      def regexp term
        term = term.source if term.is_a?(Regexp)
        term = "\\A(#{term})\\z" if Csv2hash.configuration.exact_matching

        args = [term]
        args << Regexp::IGNORECASE if Csv2hash.configuration.ignore_case

        Regexp.new(*args)
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
