module Csv2hash
  class Configuration
    attr_accessor :true_values
    attr_accessor :false_values
    attr_accessor :nil_values
    # attr_accessor :extra_values
    attr_accessor :convert
    attr_accessor :ignore_case
    attr_accessor :exact_matching

    def initialize
      self.convert = false
      self.true_values  = ['yes','y','t']
      self.false_values = ['no','n','f']
      self.nil_values   = ['nil','null']
      # self.extra_values = {} # { [] => }
      self.ignore_case = false
      self.exact_matching = false
    end
  end
end
