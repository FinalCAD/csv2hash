require 'active_support/core_ext/array/extract_options'

require_relative 'coercer'

class Cell

  attr_accessor :rules

  def initialize *args
    self.rules = args.extract_options!
    Csv2hash::Coercer.new(rules).from_yml!
  end

end
