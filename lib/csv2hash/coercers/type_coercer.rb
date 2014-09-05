module Csv2hash
  class TypeCoercer < Struct.new(:data)

    def deserialize!
      data.each do |key, value|
        _value = value.to_s.gsub(/\s+/, '').downcase
        change.each do |keys, v|
          data[key] = v if keys.include?(_value)
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
