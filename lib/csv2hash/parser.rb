module Csv2hash
  module Parser

    def treat(content)
      return content unless self.options.fetch(:sanitizer){false}
      sanitize(content)
    end

    private

    def sanitize(content)
      return content unless content.is_a?(String)
      content.gsub(/[\s]+/, ' ').strip
    end
  end
end
