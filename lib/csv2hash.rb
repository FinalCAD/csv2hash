require 'csv2hash/version'
require 'csv2hash/definition'
require 'csv2hash/definition/mapping'
require 'csv2hash/validator'

class Csv2hash
  include Validator

  attr_accessor :definition, :data_source

  def initialize definition, data_source
    @definition, @data_source = definition, data_source
  end

end