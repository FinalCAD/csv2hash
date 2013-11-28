module Parser

  def fill!
    @data = {}.tap do |data_computed|
      data_computed[:data] ||= []
      data_computed[:data] << {}.tap do |data_parsed|

        definition.rules.each do |rule|
          if rule.fetch :mappable
            x, y = rule.fetch :position
            if (nested = rule.fetch :nested)
              data_parsed[nested] ||= {}
              data_parsed[nested][rule.fetch(:key)] = data_source[x][y]
            else
              data_parsed[rule.fetch(:key)] = data_source[x][y]
            end
          end
        end

      end
    end
  end

end