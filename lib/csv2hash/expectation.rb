module Csv2hash
  module Expectation

    def unexpected_line? line, y
      return true if y < definition.header_size
      return true if self.options.fetch(:ignore_blank_line){false} and line.compact.empty?
    end

  end
end
