module Parser::Collection extend Parser

  def fill!
    @data = {}.tap do |data_computed|
      data_computed[:data] ||= []
      data_computed[:data] << {}.tap do |data_parsed|
        @data_source.each do |line|
          fill_it data_parsed, line
        end
      end
    end
  end

  def fill_it parsed_data, source_data
    definition.rules.each do |rule|
      if rule.fetch :mappable
        x = rule.fetch :position
        if (nested = rule.fetch :nested)
          parsed_data[nested] ||= {}
          parsed_data[nested][rule.fetch(:key)] = source_data[x]
        else
          parsed_data[rule.fetch(:key)] = source_data[x]
        end
      end
    end
  end

end