module Parser::Mapping extend Parser

  def fill!
    @data = {}.tap do |data_computed|
      data_computed[:data] ||= []
      data_computed[:data] << {}.tap do |data_parsed|
        fill_it data_parsed, data_source
      end
    end
  end

  def fill_it parsed_data, source_data
    definition.rules.each do |rule|
      if rule.fetch :mappable
        x, y = rule.fetch :position
        if (nested = rule.fetch :nested)
          parsed_data[nested] ||= {}
          parsed_data[nested][rule.fetch(:key)] = source_data[x][y]
        else
          parsed_data[rule.fetch(:key)] = source_data[x][y]
        end
      end
    end
  end

end