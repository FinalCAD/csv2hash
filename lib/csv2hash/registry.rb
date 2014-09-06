module Csv2hash
  class Registry
      def initialize
      @definitions = Hash.new
    end

    def [] name
      @definitions[name]
    end

    def []= name, definition
      @definitions[name] = definition
    end
  end
end
