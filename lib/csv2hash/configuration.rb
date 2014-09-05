module Csv2hash
  class Configuration
    attr_accessor :true_values
    attr_accessor :false_values
    attr_accessor :nil_values
    # attr_accessor :extra_values
    attr_accessor :convert

    def initialize
      self.convert = false
      self.true_values  = ['yes','y','t']
      self.false_values = ['no','n','f']
      self.nil_values   = ['nil','null']
      # self.extra_values = {} # { [] => }
    end
  end
end
