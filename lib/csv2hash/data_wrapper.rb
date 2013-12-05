class Csv2hash
  class DataWrapper

    attr_accessor :data, :errors, :valid, :extra_data

    def initialize
      @valid = true
      @data, @errors, @extra_data = [], [], {}
    end

    def valid?
      valid
    end

  end
end