class Csv2hash
  class DataWrapper

    attr_accessor :data, :errors, :valid

    def initialize
      self.valid = true
      self.data, self.errors = [], []
    end

    def valid?() valid ; end
  end
end