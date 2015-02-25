module Csv2hash
  class InvalidFile < ArgumentError
    def initialize
      super("Provided file has wrong format.")
    end
  end
end
