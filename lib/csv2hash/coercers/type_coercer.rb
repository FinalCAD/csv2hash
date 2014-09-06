module Csv2hash
  class TypeCoercer < Struct.new(:data)

    def deserialize!
      data.each do |line|
        line.each do |key, value|
          _value = value.to_s.strip.downcase
          change.each do |keys, v|
            line[key] = v if keys.include?(_value)
          end
        end
      end
    end

    private

    def change
      {
        Csv2hash.configuration.true_values  => true,
        Csv2hash.configuration.false_values => false,
        Csv2hash.configuration.nil_values   => nil,
      }
    end
  end
end
