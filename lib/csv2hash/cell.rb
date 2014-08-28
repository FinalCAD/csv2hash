require 'active_support/core_ext/array/extract_options'

class Cell

  attr_accessor :rules

  def initialize *args
    self.rules = args.extract_options!
  end

end
