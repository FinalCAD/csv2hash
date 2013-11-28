require 'csv2hash/version'
require 'csv2hash/definition'
require 'csv2hash/definition/mapping'
require 'csv2hash/validator'
require 'csv2hash/parser'

class Csv2hash
  include Validator
  include Parser

  attr_accessor :definition, :data_source, :data

  def initialize definition, data_source
    @definition, @data_source = definition, data_source
  end

  def parse
    definition.validate!
    definition.default!
    validate_data!
    fill!
  end

end